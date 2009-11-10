Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZKJLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZKJLnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZKJLnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:43:42 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:39969 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbZKJLnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:43:41 -0500
Date: Tue, 10 Nov 2009 12:40:22 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
Message-ID: <20091110114022.GC2998@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com> <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz> <200911042343.01957.tweek@tweek.dk> <Pine.LNX.4.64.0911050019540.1469@artax.karlin.mff.cuni.cz> <5659.1257387887@turing-police.cc.vt.edu> <Pine.LNX.4.64.0911050329130.18234@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911050329130.18234@artax.karlin.mff.cuni.cz>
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

> No, if I compile alpha version of mplayer by hand, it compiles and links 
> against whatever libraries I have on my system. If I pull it out of some 
> "testing" repository, it is already compiled and linked against libraries 
> in the same "testing" repository and it will load the system with crap.

You picked the wrong repo. Use one which contains only the wanted
package, not tons of other stuff. If there is none, create it.
 
> > Or if you're arguing "you'd give up after seeing it needed an experimental
> > libfoo", I'll counter "you'd hopefully think twice if yum said it was
> > installing a experimental mplayer, and dragging in a whole chain of pre-reqs".
> 
> ... or use --disable-libfoo if it insists on newer version and I don't 
> want to upgrade it. 

Either abdicate the feature requiring libfoo or statically link that
new version. In neither way FatELF will help here.

> Or maybe the configure scripts detects on its own that the library is 
> too old will compile without new features. Or it uses libfoo shipped 
> with the sources.

Blame mplayer folks for their crappy configure script. Automatically
switching features on presence of some libs (also *against* explicit
options), or - even worse - hard coded system lib pathes (!) is simply
insane. FatELF can't delete ignorance from jerks like Rich Felker ;-O


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
