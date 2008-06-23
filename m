Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYFWNVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYFWNVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYFWNV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:21:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:48161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYFWNVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:21:25 -0400
Date: Mon, 23 Jun 2008 15:21:22 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/5] x86: use BOOTMEM_EXCLUSIVE on 32-bit
Message-ID: <20080623152122.106a059c@kopernikus.site>
In-Reply-To: <20080623105358.GB28192@elte.hu>
References: <20080622185327.348377223@mini.kroah.org>
	<20080622190131.GB20141@suse.de>
	<87prq9dxst.fsf@skyscraper.fehenstaub.lan>
	<20080622203047.GC20800@suse.de>
	<alpine.LFD.1.10.0806221336010.2926@woody.linux-foundation.org>
	<20080623080940.GA23313@elte.hu>
	<20080623123344.0c16ed69@kopernikus.site>
	<20080623105358.GB28192@elte.hu>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-06-23 12:53]:
>
> > [1] 62b5ebe062c2801f6d40480ae3b91a64c8c8e6cb
> 
> but note that this too has dependencies, it relies on:
> 
>  # tip/x86/numa: ddeb8ef: x86: add flags parameter to reserve_bootmem_generic()
>  # tip/x86/numa: 62b5ebe: x86: use reserve_bootmem_generic() to reserve crashkernel memory on x86_64

The 2nd is not the dependency but the commit itself.

> so i've initially delayed the whole topic to v2.6.27.

Ok, you have more experience which patches should go into 2.6.26 at
that point of time, so it's acceptable for me.

> I've attached both patches below - are they really urgent enough to be 
> propagated to tip/x86/urgent and be sent to Linus? AFAICS these are 
> ancient issues with kernel crashdumping.

I only brought up that topic again because it's a regression between
2.6.22 and 2.6.23 caused by 5c3391f9f749023a49c64d607da4fb49263690eb.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
