Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbXA0A3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbXA0A3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXA0A3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:29:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:60798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbXA0A3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:29:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s5/VEaf9k0Vp8PoSCPx+hcXD4qSpoR0Al/Wrjxa428zxdA67pWatyAAKi05WB9+g2UoDbDuu4RrpIoR9CeFQZqcOWJCqDlUHjHeqYiVF9AKos+GZ6W8MAKyjSPo7dF9yfROQHWPJeVh4+QR3L0b8vBU1VFUsC7NfnrcInlPp4Es=
Message-ID: <6bffcb0e0701261629v254ed84h62ea86001c5ebeee@mail.gmail.com>
Date: Sat, 27 Jan 2007 01:29:22 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Cc: "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/07, akpm@osdl.org <akpm@osdl.org> wrote:
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz

It almost work :)

I'm getting a lot of

BUG: sleeping function called from invalid context at mm/slab.c:3038
in_atomic():0, irqs_disabled():1
no locks held by swapper/1.
irq event stamp: 537144
hardirqs last  enabled at (537143): [<c0167c31>] mod_zone_page_state+0x55/0x67
hardirqs last disabled at (537144): [<c0179569>] cache_alloc_refill+0x361/0x640
softirqs last  enabled at (536600): [<c012a38a>] __do_softirq+0xd9/0xde
softirqs last disabled at (536595): [<c012a3d9>] do_softirq+0x4a/0x7a
 [<c010544a>] show_trace_log_lvl+0x1a/0x2f
 [<c0105b63>] show_trace+0x12/0x14
 [<c0105c25>] dump_stack+0x16/0x18
 [<c011e2c0>] __might_sleep+0xe5/0xeb
 [<c0179c09>] kmem_cache_alloc+0x28/0xe4
 [<c0179601>] cache_alloc_refill+0x3f9/0x640
 [<c0179c79>] kmem_cache_alloc+0x98/0xe4
 [<c011b2a3>] pgd_alloc+0x12/0x14
 [<c0122c07>] mm_init+0xa3/0xf5
 [<c0124229>] mm_alloc+0x2b/0x2e
 [<c0182ac3>] do_execve+0x81/0x210
 [<c01026a0>] sys_execve+0x3f/0x8a
 [<c01043f0>] syscall_call+0x7/0xb
 =======================

http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/mm-dmesg
http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
