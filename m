Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbXHWFrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbXHWFrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXHWFrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:47:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59571 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbXHWFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:47:06 -0400
Date: Thu, 23 Aug 2007 11:17:09 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       kexec-ml <kexec@lists.infradead.org>, Neil Horman <nhorman@redhat.com>,
       Bernhard Walle <bwalle@suse.de>, Don Zickus <dzickus@redhat.com>,
       Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH 0/3] vmcoreinfo support for dump filtering
Message-ID: <20070823054709.GC365@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070822210838oomichi@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822210838oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:08:38PM +0900, Ken'ichi Ohmichi wrote:
> 
> Hi Andrew,
> 
> This patch set frees the restriction that makedumpfile users should
> install a vmlinux file (including the debugging information) into
> each system.
> 
> makedumpfile command is the dump filtering feature for kdump.
> It creates a small dumpfile by filtering unnecessary pages for the
> analysis. To distinguish unnecessary pages, it needs a vmlinux file
> including the debugging information. These days, the debugging package
> becomes a huge file, and it is hard to install it into each system.
> 
> To solve the problem, kdump developers discussed it at lkml and kexec-ml.
> As the result, we reached the conclusion that necessary information
> for dump filtering (called "vmcoreinfo") should be embedded into the
> first kernel file and it should be accessed through /proc/vmcore
> during the second kernel.
> (http://www.uwsg.iu.edu/hypermail/linux/kernel/0707.0/1806.html) 
> 
> Dan Aloni created the patch set for the above implementation.
> (http://www.uwsg.iu.edu/hypermail/linux/kernel/0707.1/1053.html)
> 
> And I updated it for multi architectures and memory models.
> (http://lists.infradead.org/pipermail/kexec/2007-August/000479.html)
> 
> 
> PATCH SET:
> [1/3] [linux] Add vmcoreinfo
>   The patch is for linux-2.6.22.
>   The patch adds the vmcoreinfo data. Its address and size are output
>   to /sys/kernel/vmcoreinfo.
> 

Looks good to me.

Thanks
Vivek
