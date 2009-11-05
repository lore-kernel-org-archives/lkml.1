Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZKECwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZKECwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZKECwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:52:31 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:53076 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbZKECwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:52:31 -0500
Date: Thu, 5 Nov 2009 03:52:35 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Valdis.Kletnieks@vt.edu
cc: Martin Nybo Andersen <tweek@tweek.dk>,
       kevin granade <kevin.granade@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <5659.1257387887@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0911050329130.18234@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com>
 <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz>
 <200911042343.01957.tweek@tweek.dk>           
 <Pine.LNX.4.64.0911050019540.1469@artax.karlin.mff.cuni.cz>
 <5659.1257387887@turing-police.cc.vt.edu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Nov 2009, Valdis.Kletnieks@vt.edu wrote:

> On Thu, 05 Nov 2009 00:55:53 +0100, Mikulas Patocka said:
> 
> > In some situations, the package manager is even more dangerous than manual 
> > install. For example, if you are manually installing new alpha-quality 
> > version of mplayer, and it is buggy, you end up with a working system with 
> > broken mplayer. If you install alpha-quality version from some package 
> > repository, it may need experimental version of libfoo, that needs 
> > experimental version of libfee, that needs experimental version of glibc, 
> > that contains a bug 
> 
> Total bullshit.  You know *damned* well that if you were installing that 
> alpha version of mplayer by hand, and it needed experimental libfoo, 
> you'd go and build libfoo by hand, and then build the experimental 
> libfee by hand, and then shoehorn in that glibc by hand, and bricked 
> your system anyhow.

No, if I compile alpha version of mplayer by hand, it compiles and links 
against whatever libraries I have on my system. If I pull it out of some 
"testing" repository, it is already compiled and linked against libraries 
in the same "testing" repository and it will load the system with crap.

That is the unfortunate reality of not having a binary standard :-(

> Or if you're arguing "you'd give up after seeing it needed an experimental
> libfoo", I'll counter "you'd hopefully think twice if yum said it was
> installing a experimental mplayer, and dragging in a whole chain of pre-reqs".

... or use --disable-libfoo if it insists on newer version and I don't 
want to upgrade it. Or maybe the configure scripts detects on its own that 
the library is too old will compile without new features. Or it uses 
libfoo shipped with the sources.

But if the binary in the package is compiled with --enable-libfoo, there 
is no other way. It forces libfoo upgrade.

Mikulas
