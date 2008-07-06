Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYGFPVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYGFPVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbYGFPVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:21:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:51918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbYGFPVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:21:11 -0400
Subject: Re: [PATCH] dsp56k: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: Fredrik Noring <noring@nocrew.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lars@nocrew.org, tomas@nocrew.org
In-Reply-To: <A3D470E0-953E-40D6-BF5A-D06B76451154@nocrew.org>
References: <1215253496.7816.7.camel@jaswinder.satnam>
	 <A3D470E0-953E-40D6-BF5A-D06B76451154@nocrew.org>
Content-Type: text/plain; charset=utf8
Date: Sun, 06 Jul 2008 20:43:44 +0530
Message-Id: <1215357224.2817.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ﻿Fredrik,

On Sun, 2008-07-06 at 15:36 +0200, Fredrik Noring wrote:
> Hi Jaswinder,
> 
> 5 jul 2008 kl. 12.24 skrev Jaswinder Singh:
> > +	for (i = 0; i < fw->size; i + 3) {
> 
> Are you sure about "i + 3" in this loop? Isn't GCC complaining,  
> something like "statement with no effect"?
> 

Fixed, Thanks.

> > +Driver: ATARI_DSP56K - Atari DSP56k support
> > +
> > +File: dsp56k/bootstap.bin
> > +
> > +Licence: Unknown
> > +
> > +Found in hex form in kernel source.
> 
> I wrote this DSP56k assembler code in 1995. It's a trivial copy loop  
> that loads the main DSP program into memory. Please consider it GPL  
> like the driver code it came from.
> 
> A disassembler would easily recreate the original ~50 lines of  
> assembler source code, in case you'd like to assemble it with the rest  
> of kernel. :)
> 

Fixed.

Updated patch :
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=4f5b8828113ea857a7b590b7dbb8a5ee78103de4

Thanks for you comments.

Thank you,

Jaswinder Singh.

