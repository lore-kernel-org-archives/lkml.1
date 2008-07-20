Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYGTMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYGTMvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbYGTMvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:51:38 -0400
Received: from ns1.suse.de ([195.135.220.2]:44747 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbYGTMvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:51:37 -0400
Date: Sun, 20 Jul 2008 14:51:32 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Hansen <haveblue@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
 trace_hardirqs_on_caller
Message-ID: <20080720145132.1df6b10d@kopernikus.site>
In-Reply-To: <20080719232021.GA6476@suse.de>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	<200807190928.33978.m.kozlowski@tuxland.pl>
	<19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	<19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
	<20080719221723.GB5578@suse.de>
	<19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com>
	<19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
	<20080719225817.GA6264@suse.de>
	<19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com>
	<20080719232021.GA6476@suse.de>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
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

* Greg KH <gregkh@suse.de> [2008-07-19 16:20]:
> 
> > Maybe the firmware memmap code can simply run a little later in the
> > boot sequence?
> 
> Possibly.  I wonder why this is only a problem on your machine and not
> on anything that Ingo tested?

It also was on my machine when I tested it on linux-next. That's why I
made the patch as described in 

http://article.gmane.org/gmane.linux.kernel.kexec/1882.

However, it was not in tip tree. It seems to be the combination of
patches, but I don't know why and I didn't have the time to find it
out, the fix was much easier.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
