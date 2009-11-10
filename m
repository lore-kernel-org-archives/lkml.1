Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZKJL7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZKJL7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZKJL7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:59:49 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:42594 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbZKJL7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:59:48 -0500
Date: Tue, 10 Nov 2009 12:57:15 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
Message-ID: <20091110115715.GD2998@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <20091104165407.1481bc29@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz> <200911041848.48721.tweek@tweek.dk> <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:

> Some Windows programs force upgrade, but not in yearly cycles, like Linux 
> programs. Majority of programs still work on XP shipped in 2001.

You really use old, outdated software on production systems ?

> > Being able to upgrade at least Debian -- and others as well -- without the 
> > need to attend the computer is IMHO one of Linux' biggest wins.
> 
> When I did it (from Etch to Lenny), two programs that I have compiled 
> manually ("vim" and "links") stopped working because Etch and Lenny have 
> binary-incompatible libgpm.

Distro issue. If ABI changes, the binary package has get a different name.
 
> Static linking doesn't work for any program that needs plug-ins (i.e. 
> you'd have one glibc statically linked into the program and another glibc 
> dynamically linked with a plug-in and these two glibcs will beat each 
> other).

Plugins are crap by design. Same situation like w/ kernel modules:
you need them compiled against the right version of the main program,
in fact: on binary packaging they are *part* of the main program which
just happen to be loaded on-demand. If you want to split them up into
several packages, you'll end up in a dependency nightmare.

> I mean this --- the distributions should agree on a common set of 
> libraries and their versions (call this for example "Linux-2010 
> standard"). This standard should include libraries that are used 
> frequently, that have low occurence of bugs and security holes and that 
> have never had an ABI change.

See the discussion on stable kernel module ABI.

> Software developers that claim compatibility with the standard will link 
> standard libraries dynamically and must use static linking for all 
> libraries not included in the standard. Or they can use dynamic linking 
> and ship the non-standard library with the application in its private 
> directory (so that nothing but that application links against it).

Yeah, ending up in the windows-world maintenance hell. Dozens of packages
will ship dozens of own library copies, making their own private changes, 
not keeping up with upstream, so carrying around ancient bugs.

Wonderful idea.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
