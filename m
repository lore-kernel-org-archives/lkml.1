Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbZKDWm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbZKDWm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbZKDWm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:42:58 -0500
Received: from mail1-hoer.fullrate.dk ([90.185.1.42]:65027 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925AbZKDWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:42:58 -0500
From: Martin Nybo Andersen <tweek@tweek.dk>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: package managers [was: FatELF patches...]
Date: Wed, 4 Nov 2009 23:43:01 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5; KDE/4.3.2; x86_64; ; )
Cc: kevin granade <kevin.granade@gmail.com>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com> <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911042343.01957.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009 23:05:17 Mikulas Patocka wrote:
> > I think the important question here is what is is exactly that the
> > package manager *did* to break the app you are talking about?
> 
> It interferred with my will to install the version of the software that I
> want.
> 
> > be, and not magically be able to discern that you've replaced one of
> > the most core packages in the system (which, by the way is most
> > definitely not something that %99.999 of users are going to try)
> 
> If you need new 3D driver because of better gaming performance ... if you
> need new lame because it encodes mp3 better ... if you need new libsane
> because it supports the new scanner that you have ... you are going to
> face the same problems like me when I needed new binutils. But the big
> problem is that persons needing these things usually don't have enough
> skills to install the software on their own and then fight with the
> package management system.
> 
> On Windows, the user can just download the EXE, run it, click
> next-next-next-finish and have it installed. There is no package
> management that would try to overwrite what you have just installed.

Exactly. There is nothing to help you from installing incompatible software 
(ie libraries). If your next-next-next-finish installer overwrites a crucial 
library, you're screwed. The package manager, on the other hand, knows about 
all your installed files and their dependencies and conflicts.

If you really want to fiddle with your own software versions, dependencies, and 
conflicts, then the equivs package is a perfect helper, which lets you create 
virtual Debian packages (empty packages with dependencies and such).
For instance, I compile mplayer directly from the subversion repository - 
however I still have some packages installed, which depends on mplayer. Here 
the virtual mplayer package keeps apt and friends from complaining.

My home brewed mplayer will still fail to work when a needed library is gone, 
but now I only have about a dozen apps that can break this way (all are nicely 
installed under /usr/local/stow btw).

Without the package manager, it would have been all of them.

Another nice thing about apt: It's an installer, that frees you from the next-
next-next steps. ;-)

-Martin
