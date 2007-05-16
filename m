Return-Path: <linux-kernel-owner+w=401wt.eu-S1762478AbXEPQaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762478AbXEPQaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXEPQaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:30:10 -0400
Received: from gw.goop.org ([64.81.55.164]:51898 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbXEPQaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:30:08 -0400
Message-ID: <464B318F.1060309@goop.org>
Date: Wed, 16 May 2007 09:30:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: boot failure under qemu
References: <464ABF7C.1000307@goop.org> <464B2762.7040508@zytor.com>
In-Reply-To: <464B2762.7040508@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> There are a number of highly odd things about your dump, in particular,
> %es == 0x8100 at this point, which means the constraint %cs == %ds ==
> %es == %ss has been violated in this code; this should only happen
> locally inside an assembly routine or asm() statement.  Another bizarre
> thing is that %ebp, which apparently is supposed to contain the base at
> this point, is *also* set to 0x8100.
>   

Yeah, I noticed the segment state was all over the place.

> I have been using Qemu (as well as Bochs) to develop and test the code,
> so obviously it Works For Me[TM].  Please describe the entry conditions
> in more detail; in particular, what did you use to load the kernel?
>   

qemu -kernel bzImage -hda filesystem.img

> Also, could you send me your .config and simulation image?
>   

Yep, separate mail.

    J
