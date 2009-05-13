Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZEMPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZEMPxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757774AbZEMPxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:53:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:47361 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbZEMPxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=luvCi5e8iKHp9mNiUG0JtrXUg3VTCcSlIoOrTExIU070IExXhVn+VgWseKxtayHMU3
         DzDSWLqnCah22Jn7dzbOORojRzkA/rQj/CQMtdvWPUJj4Ahu55ZgRyUM3Da35hJgGFtU
         8EXrP1thxZAg79xDA/1o3xdevXaOhTkgkZxbk=
MIME-Version: 1.0
In-Reply-To: <4A09CF53.2010400@housetosell.net>
References: <4A09CF53.2010400@housetosell.net>
Date: Wed, 13 May 2009 17:53:02 +0200
Message-ID: <9ea470500905130853o65463da0md6dc4380c17a8ec1@mail.gmail.com>
Subject: Re: 2.6.30-rc4 kernel
From: Borislav Petkov <petkovbb@googlemail.com>
To: linux@housetosell.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 12, 2009 at 9:34 PM, rob <rob1@housetosell.net> wrote:
> Hi
>
> I think there may be a problem with the 2.6.30 kernel that is
> linux-2.6.29.tar.bz2 patched with patch-2.6.30-rc4.bz2 this is the message
> when it was booting:-
>
> kernel panic -  not syncing : fatel exception in interupt
>
> pid:0 com: swapper tainted: G   D     2.6.30-rc4 #10
>
> [<c0116e64>] Panic+0x3e/0xd8
> [<c0104921>] oops_end+0x78/0x83
> [<c010fee8>] no_context+0x104/0x10d
> [<c0110155>] do_page_fault+0x0/0x1e0
> [<c01100d2>] bad_area_semaphore+0xa/0xc
> [<c0371865>] error_code+0x65/0x6c
> [<c0110155>] do_page_fault+0x0/0x1e0
> [<c027dafc>] ide_complete_rq+0xf/0x3b
> [<c02870a0>] cdrom_newpc_intr+0x64d/0x6cd
> [<c0286a53>] cdrom_newpc_intr+0x0/0x6cd
> [<c027dcc2>] ide_intr+0x109/0x161
> [<c0132298>] handle_IRQ_event+0x54/0xc7
> [<c013354a>] handle_level_irq+0x4f/0x85
> [<c0103df7>] handle_irq+0x17/0x20
> [<c0103da5>] do_IRQ+0x2b/0x66
> [<c0102be9>] common_interupt+0x29/0x30
> [<c0480000>] cmd40x_init+0x2ac/0x38d
> [<c0106db3>] default_idle+0x25/0x38
> [<c01019be>] cpu_idle+0x19/0x2d
> [<c0468907>] start_kernel+0x23f/0x242


can you do

objdump -d drivers/ide/ide-cd.o > ide-cd.dsm

and

make drivers/ide/ide-cd.s

and send me the .dsm and .s files.

Thanks.

-- 
Regards/Gruss,
Boris
