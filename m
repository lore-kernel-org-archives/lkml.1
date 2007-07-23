Return-Path: <linux-kernel-owner+w=401wt.eu-S936614AbXGWVHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936614AbXGWVHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936509AbXGWVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:07:20 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48366 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936321AbXGWVHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:07:18 -0400
Date: Tue, 24 Jul 2007 06:06:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Adrian McMenamin <adrianmcmenamin@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Problems with framebuffer in 2.6.22-git17
Message-ID: <20070723210649.GA20049@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	linux-kernel@vger.kernel.org
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com> <1185146563.6370.8.camel@daplas> <8b67d60707231324k28f3cd45p287418fd77feaf00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60707231324k28f3cd45p287418fd77feaf00@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:24:27PM +0100, Adrian McMenamin wrote:
> OK, that certainly seems to make a difference - the box doesn't crash but it
> generates a lot of error messages - though as I have patched this with my
> dma patch that isn't one of them:
> 
> / # [   31.912380] BUG: scheduling while atomic: 10-udev.hotplug
[snip]
> [   32.063730] [<8c00f782>] __cond_resched+0x1a/0x40
> [   32.068621] [<8c15adf4>] cond_resched+0x30/0x48
> [   32.073286] [<8c15b6ba>] mutex_lock+0xa/0x50
> [   32.077687] [<8c00c606>] copy_user_page+0x86/0x134
> [   32.082639] [<8c03b3fa>] __do_fault+0x142/0x340
> [   32.087309] [<8c03b958>] handle_mm_fault+0x2c6/0x556
> [   32.092428] [<8c00b890>] do_page_fault+0xa4/0x2c0
> [   32.097279] [<8c03e09e>] do_mmap_pgoff+0x23e/0x26c
> [   32.102215] [<8c00528a>] old_mmap+0x66/0xb4
> [   32.106517] [<8c00529a>] old_mmap+0x76/0xb4
> [   32.110834] [<8c0070e8>] ret_from_exception+0x0/0x14
> [   32.116014]

As I already pointed out, none of these are related to the fb. So if
your pvr2fb problems went away, then the matter is resolved. These faults
are a completely different (and known) issue.
