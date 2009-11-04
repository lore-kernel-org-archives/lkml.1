Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbZKDVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbZKDVLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbZKDVLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:11:43 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:36200 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbZKDVLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:11:42 -0500
Date: Wed, 4 Nov 2009 22:11:47 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Valdis.Kletnieks@vt.edu
cc: Martin Nybo Andersen <tweek@tweek.dk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <23950.1257367315@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
 <200911041848.48721.tweek@tweek.dk> <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
 <22108.1257364949@turing-police.cc.vt.edu>           
 <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz>
 <23950.1257367315@turing-police.cc.vt.edu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > No, all they need to do is bump the .so version number.
> > 
> > That's what Debian did. Obviously, I can extract the old library from the 
> > old package. But non-technical desktop user can't.
> 
> But the non-technical user probably wouldn't have hand-compiled vim and links
> either, so how would they get into that situation?

Non-technical users won't hand-compile but they want third party software 
that doesn't come from the distribution. And package management system 
hates it. Truly. It is written with the assumption that everything 
installed is registered in the package database.

Another example: I needed new binutils because it had some bugs fixed over 
standard Debian binutils. So I downloaded .tar.gz from ftp.gnu.org, 
compiled it, then issued a command to remove the old package, passed it a 
flag to ignore broken dependencies and then typed make install to install 
new binaries. --- guess what --- on any further invocation of dselect it 
complained that there are broken dependencies (the compiler needs 
binutils) and tried to install the old binutils package!

Why is the package management so stupid? Why can't it check $PATH for "ld" 
and if there is one, don't try to install it again?

After few hours, I resolved the issue by creating an empty "binutils" 
package and stuffing it into the database.

Now, if I were not a programmer ... if I were an artist who needs the 
latest version of graphics software, if I were a musican who needs the 
latest version of audio software, if I were a gamer who needs the latest 
version of wine ... I'd be f'cked up. That's why I think that package 
management is an evil feature hurts desktop users. As a technical user, I 
somehow solve these quirks and install what I want, as a non-technical 
user, I wouldn't have a chance.

Mikulas
