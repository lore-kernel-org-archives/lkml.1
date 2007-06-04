Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXFDPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXFDPK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbXFDPKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:10:40 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:50317 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020AbXFDPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:10:39 -0400
Message-ID: <46642AB3.1000907@gmail.com>
Date: Mon, 04 Jun 2007 17:07:31 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jens Axboe <axboe@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Q] Bio traversal trouble?
References: <4663DE68.5030200@gmail.com>
In-Reply-To: <4663DE68.5030200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2007 11:42 AM, Rene Herman wrote:

[ ... ]

> Unfortunately, I can make the box oops by just doing enough of those dd 
> runs in a row (this one with bs=2k count=128, oopsed the seventh time or 
> something):
> 
> ===
> BUG: unable to handle kernel paging request at virtual address 8c1d2071
>  printing eip:
> c10a6d6f
> *pde = 00000000
> Oops: 0002 [#1]
> Modules linked in: mitsumi nfsd exportfs lockd sunrpc nls_cp437 msdos 
> fat nls_base
> CPU:    0
> EIP:    0060:[<c10a6d6f>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.21.3 #1)
> EIP is at ioread8_rep+0x20/0x31
> eax: 00010000   ebx: 00010300   ecx: 00000800   edx: 00000300
> esi: c3145b30   edi: 8c1d2071   ebp: 8c1d2071   esp: c3145aec
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process dd (pid: 1770, ti=c3145000 task=c3114110 task.ti=c3145000)
> Stack: 00000000 c3a7ad48 c486504d c4865ab7 00000006 50020034 c1015f7b 
> 00000292
>        00000000 00520300 00000100 0007e000 00000000 c3340300 c10a0531 
> 00000000
>        c12adf60 00000000 00000001 00000000 00000000 00000000 dead4ead 
> ffffffff
> Call Trace:
>  [<c486504d>] __mitsumi_get_frame+0xc/0x16 [mitsumi]
>  [<c4865ab7>] mitsumi_get_frame+0x120/0x134 [mitsumi]
>  [<c1015f7b>] lock_timer_base+0x15/0x2f
>  [<c10a0531>] cfq_set_request+0x0/0x144

Perhaps interesting (and perhaps not) -- I've been unable to reproduce the OOPS 
after rebooting with elevator=as.

Rene.
