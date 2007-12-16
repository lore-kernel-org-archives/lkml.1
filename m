Return-Path: <linux-kernel-owner+w=401wt.eu-S933484AbXLQAal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484AbXLQAal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763631AbXLQAad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:30:33 -0500
Received: from ozlabs.org ([203.10.76.45]:51292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762134AbXLQAac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:30:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18277.40798.828760.919571@cargo.ozlabs.ibm.com>
Date: Mon, 17 Dec 2007 08:57:50 +1100
From: Paul Mackerras <paulus@samba.org>
To: Greg KH <gregkh@suse.de>
Cc: David Miller <davem@davemloft.net>, venkatesh.pallipadi@intel.com,
       ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
In-Reply-To: <20071214063424.GB10100@suse.de>
References: <20071213235543.568682000@intel.com>
	<20071213235712.813201000@intel.com>
	<20071214001932.GA10389@suse.de>
	<20071213.163505.14070110.davem@davemloft.net>
	<20071214063424.GB10100@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:

> Ok, sorry, it wasn't blindingly obvious that this was for pci sysfs
> devices that are mmaped, that makes a bit more sense.
> 
> But I'd like to see what ioctl is wanted here first.

I believe the ioctl would be to set whether the mapping goes to I/O or
memory space, and whether write-combining is allowed.

So the alternative to the ioctl would be to have multiple files in
sysfs, one per combination of modes -- i.e., 4 files, or 3 if we
exclude the "I/O with write combining" mode, which would be
reasonable.

Paul.
