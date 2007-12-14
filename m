Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbXLNJ0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbXLNJ0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbXLNJ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:26:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41597 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLNJ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:26:36 -0500
Subject: Re: [2.6 patch] videobuf-core.c locking fixes
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Shane <gnome42@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
       Brandon Philips <brandon@ifup.org>, linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <fa4052ef0712121322h3ce78a39ve4fd1e10fafe3d15@mail.gmail.com>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	 <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota>
	 <20071212120308.GG14204@stusta.de> <1197469316.4744.22.camel@gaivota>
	 <fa4052ef0712120837i36cee3elbe0a5170f5904d2f@mail.gmail.com>
	 <fa4052ef0712121057o51230b22ycb79723091438779@mail.gmail.com>
	 <20071212194454.GF10069@stusta.de>
	 <fa4052ef0712121235x54e1837cs2efe4ce5c6e0e84d@mail.gmail.com>
	 <fa4052ef0712121322h3ce78a39ve4fd1e10fafe3d15@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Dec 2007 07:26:15 -0200
Message-Id: <1197624375.4632.44.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-12-12 às 16:22 -0500, Shane escreveu:
> > Yes it does! I was just going to send the same patch myself :)
> 
> But, I am now seeing some errors that weren't there in 2.6.23
> 
> kernel: bttv0: SCERR @ 1fa0401c,bits: HSYNC OFLOW SCERR*
> last message repeated 15 times
> kernel: bttv0: timeout: drop=16 irq=105615/105615, risc=1fa0401c,
> bits: HSYNC OFLOW
> kernel: bttv0: reset, reinitialize
> kernel: bttv0: PLL can sleep, using XTAL (28636363).
> 
> kernel: bttv0: SCERR @ 1fa0401c,bits: HSYNC OFLOW SCERR*
> last message repeated 15 times
> kernel: bttv0: timeout: drop=16 irq=106741/106741, risc=1fa0401c,
> bits: HSYNC OFLOW
> kernel: bttv0: reset, reinitialize
> kernel: bttv0: PLL can sleep, using XTAL (28636363).
> 
> These happen occasionally and it causes an EIO DQBUF
> error and the application has to re queue the buffers but it
> recovers OK. Not sure if it causes some sort of internal
> kernel corruption that will only be noticed later possibly?
> 
> I am using 15 userptr buffers so whatever is happening may
> be happening once per buffer sometimes. dunno

You may see such troubles with weak signals, where bttv is not capable of getting the proper sync.

-- 
Cheers,
Mauro

