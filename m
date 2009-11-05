Return-Path: <linux-kernel-owner+w=401wt.eu-S1751097AbZKEAFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbZKEAFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZKEAFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:05:19 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:59092 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZKEAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:05:18 -0500
Date: Thu, 5 Nov 2009 01:05:23 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Valdis.Kletnieks@vt.edu
cc: Martin Nybo Andersen <tweek@tweek.dk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <31644.1257376315@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0911050057280.1469@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
 <200911041848.48721.tweek@tweek.dk> <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
 <22108.1257364949@turing-police.cc.vt.edu> <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz>
 <23950.1257367315@turing-police.cc.vt.edu>           
 <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>
 <31644.1257376315@turing-police.cc.vt.edu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Walking $PATH is even worse - if it finds a /usr/local/bin/ld, it's a pretty
> damned good guess that it's there *because* it's not the /bin/ld that the
> system shipped with.  So why should it use it?

If it finds /usr/local/bin/ld it's because the admin installed it there 
--- and he installed it there because he wants it to be used. So it's OK 
to use it.

Anyway, if you have both /usr/bin/ld and /usr/local/bin/ld, you are in a 
pretty unpleasant situation because different programs search for them in 
a different order and you never know which one will be used. (i.e. what if 
./configure scripts prepends /usr/local/bin to $PATH ... or if it prepends 
/usr/bin? who knows - no one can check all ./configure scripts. These 
scripts do crazy things just because it worked around some flaw on some 
ancient Unix system).

Mikulas
