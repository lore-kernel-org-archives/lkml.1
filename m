Return-Path: <linux-kernel-owner+w=401wt.eu-S1161301AbXCGHcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161301AbXCGHcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161259AbXCGHbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:31:45 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59010 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161204AbXCGH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:27:55 -0500
Date: Wed, 7 Mar 2007 12:27:04 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 0/20] x86_64 Relocatable bzImage support (V4)
Message-ID: <20070307065703.GA23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is another attempt on x86_64 relocatable bzImage patches(V4). This
patchset makes a bzImage relocatable and same kernel binary can be loaded
and run from different physical addresses.

As on now, this mainly helps distros who have to ship an extra kernel compiled
for a different physical address to capture the kernel crash dump. This
patchset will allow distros and kdump users to use production kernel itself
as dump capture kernel and there is no need to ship/build an extra kernel.
I am hopeful people will find other interesting usages down the line.

Eric has done all the heavy weight lifting requird to make this patchset
work. Last time I posted this patchset (V3), there were minor comments
which I have taken care of. Following are the changes since V3.

- Reduced the usage of _AC() macro to only shift operations, as per 
  Andi's comment.
- Restored the CONFIG_PHYSICAL_START option.
- Fixed few bugs with suspend to disk code path.

It would be good if these patches get into -mm so that it can undergo more
testing. I have been testing them and these just work fine for me.

Thanks
Vivek
