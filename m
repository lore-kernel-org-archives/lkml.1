Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYGFNh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYGFNh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYGFNhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:37:50 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:34468 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbYGFNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:37:49 -0400
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lars@nocrew.org, tomas@nocrew.org
Message-Id: <A3D470E0-953E-40D6-BF5A-D06B76451154@nocrew.org>
From: Fredrik Noring <noring@nocrew.org>
To: Jaswinder Singh <jaswinder@infradead.org>
In-Reply-To: <1215253496.7816.7.camel@jaswinder.satnam>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] dsp56k: use request_firmware
Date: Sun, 6 Jul 2008 15:36:58 +0200
References: <1215253496.7816.7.camel@jaswinder.satnam>
X-Mailer: Apple Mail (2.926)
X-Originating-IP: 83.252.213.252
X-Scan-Result: No virus found in message 1KFUR2-0007bj-7p.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KFUR2-0007bj-7p 4ac2f50e78b4ebf53f205b34f83e8cfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

5 jul 2008 kl. 12.24 skrev Jaswinder Singh:
> +	for (i = 0; i < fw->size; i + 3) {

Are you sure about "i + 3" in this loop? Isn't GCC complaining,  
something like "statement with no effect"?

> +Driver: ATARI_DSP56K - Atari DSP56k support
> +
> +File: dsp56k/bootstap.bin
> +
> +Licence: Unknown
> +
> +Found in hex form in kernel source.

I wrote this DSP56k assembler code in 1995. It's a trivial copy loop  
that loads the main DSP program into memory. Please consider it GPL  
like the driver code it came from.

A disassembler would easily recreate the original ~50 lines of  
assembler source code, in case you'd like to assemble it with the rest  
of kernel. :)

Thanks,
Fredrik

