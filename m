Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYBIWez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYBIWez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYBIWes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:34:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49615 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYBIWer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:34:47 -0500
Date: Sat, 9 Feb 2008 14:34:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz
Subject: Re: how to tell i386 from x86-64 kernel
Message-ID: <20080209143430.193131d8@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0802092112510.6917@fbirervta.pbzchgretzou.qr>
References: <20080201004212.GA2818@elf.ucw.cz>
	<2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
	<Pine.LNX.4.64.0802010157370.4864@fbirervta.pbzchgretzou.qr>
	<20080201125350.04211519@Varda>
	<Pine.LNX.4.64.0802092112510.6917@fbirervta.pbzchgretzou.qr>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 21:13:43 +0100 (CET)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Feb 1 2008 12:53, Alejandro Riveira Fernández wrote:
> >> 
> >> # uname -m
> >> I won't tell you.
> >> # linux32 uname -m
> >> i686
> >
> > Ubuntu 7.10 64 bit userland 2.6.24
> >
> >$ uname -m
> >x86_64
> >$ linux32 uname -m
> >i686
> 
> What I am saying is that uname(2) does not reliably tell you whether
> you have a 64-bit kernel underneath unless you have other sources of 
> information.

that's sort of a rabbit-and-the-frog problem. The 32 bit emulator tries to
look EXACTLY like the 32 bit kernel, and it really should.
If someone wants a method to detect even that... we would really want
to know the exact usecase.. because very likely it's the wrong answer
to some other problem ;-)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
