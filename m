Return-Path: <linux-kernel-owner+w=401wt.eu-S1763956AbXGaO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763956AbXGaO6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761153AbXGaO6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:58:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44060 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760890AbXGaO6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:58:10 -0400
Date: Tue, 31 Jul 2007 16:58:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stefan Seyfried <seife@suse.de>, suspend-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [rft] Kill junk from s2ram resume paths
Message-ID: <20070731145821.GL2087@elf.ucw.cz>
References: <20070731121246.GF2087@elf.ucw.cz> <20070731140140.GJ2087@elf.ucw.cz> <20070731144334.GC6973@suse.de> <200707311703.44096.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707311703.44096.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > > diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> > > index 1415da1..9cebef7 100644
> > > --- a/arch/i386/kernel/acpi/wakeup.S
> > > +++ b/arch/i386/kernel/acpi/wakeup.S
> > > @@ -28,21 +28,6 @@ #define BEEP \
> > >  	movb	$15, %al; 	\
> > >  	outb	%al, $66;
> > >  
> > > -#define BEEP \
> > > -	inb	$97, %al; 	\
> > > -	outb	%al, $0x80; 	\
> > > -	movb	$3, %al; 	\
> > > -	outb	%al, $97; 	\
> > > -	outb	%al, $0x80; 	\
> > > -	movb	$-74, %al; 	\
> > > -	outb	%al, $67; 	\
> > > -	outb	%al, $0x80; 	\
> > > -	movb	$-119, %al; 	\
> > > -	outb	%al, $66; 	\
> > > -	outb	%al, $0x80; 	\
> > > -	movb	$15, %al; 	\
> > > -	outb	%al, $66;
> > > -
> > >  ALIGN
> > >  	.align	4096
> > >  ENTRY(wakeup_start)
> > 
> > This hunk rejected for me (against 2.6.23-rc1), but i'm testing x86_64, so
> > it did not matter ;-)
> 
> I think it's gone in favor of the more sophisticated beeping
> > > support.

No. It was merge problem on my side, I actually had _two_ times the
beeping macro.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
