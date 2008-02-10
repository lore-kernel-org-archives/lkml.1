Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYBJB1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYBJB1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 20:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYBJB1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 20:27:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2060 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbYBJB1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 20:27:22 -0500
Date: Sun, 10 Feb 2008 01:27:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz
Subject: Re: how to tell i386 from x86-64 kernel
Message-ID: <20080210012714.GA4618@ucw.cz>
References: <20080201004212.GA2818@elf.ucw.cz> <2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com> <Pine.LNX.4.64.0802010157370.4864@fbirervta.pbzchgretzou.qr> <20080201125350.04211519@Varda> <Pine.LNX.4.64.0802092112510.6917@fbirervta.pbzchgretzou.qr> <20080209143430.193131d8@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080209143430.193131d8@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-02-09 14:34:30, Arjan van de Ven wrote:
> On Sat, 9 Feb 2008 21:13:43 +0100 (CET)
> Jan Engelhardt <jengelh@computergmbh.de> wrote:
> 
> > 
> > On Feb 1 2008 12:53, Alejandro Riveira Fernández wrote:
> > >> 
> > >> # uname -m
> > >> I won't tell you.
> > >> # linux32 uname -m
> > >> i686
> > >
> > > Ubuntu 7.10 64 bit userland 2.6.24
> > >
> > >$ uname -m
> > >x86_64
> > >$ linux32 uname -m
> > >i686
> > 
> > What I am saying is that uname(2) does not reliably tell you whether
> > you have a 64-bit kernel underneath unless you have other sources of 
> > information.
> 
> that's sort of a rabbit-and-the-frog problem. The 32 bit emulator tries to
> look EXACTLY like the 32 bit kernel, and it really should.
> If someone wants a method to detect even that... we would really want
> to know the exact usecase.. because very likely it's the wrong answer
> to some other problem ;-)

dmesg should really really tell you 32 vs. 64 bit, at the first line
where it prints versions... so you easily know what you are dealing
with when someone sends a bugreport.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
