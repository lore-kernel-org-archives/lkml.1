Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYC2WRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYC2WRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYC2WQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:16:53 -0400
Received: from n22.bullet.mail.mud.yahoo.com ([68.142.206.161]:48304 "HELO
	n22.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751845AbYC2WQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:16:52 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 812530.83177.bm@omp105.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=awJt5lVd5a99G3cPbmzk5spWo8CeAYtvGgOHGaxRyjf3Fjp2wmO0FfoqrorHurppmF0NGQ/jKKO9ImqFJdZmGLppZQTdth9K3EwFTacDUioJTpv/nEePz9fhf7y/k3NNFNX46Y2Nm1SA/Vc0u/vyj90tY0oZayd11Wqj3NSJexQ=;
X-YMail-OSG: VY_.D.gVM1k7E_YfJjBDSnuzW.fi3q_.8TuaBI9Kqh2g1XHq9LZ.1DfYXZReO8ryEu5YE7c7vMCOp6EmF.FxDRStDVOBZEO2amvZxGtX.TM_xEEDbgcwtWWXlRQ-
Date: Sat, 29 Mar 2008 23:16:50 +0100 (CET)
From: Michael Meyer <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080329212203.GB2153@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <548290.15521.qm@web25803.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pavel Machek <pavel@ucw.cz> schrieb:

> Hi!
> 
> > > > what is the difference between booting a dual core
> > > > machine with "maxcpus=1" or by deactivating the second
> > > > core at run time with "echo 0 >
> > > > /sys/devices/system/cpu/cpu1/online"?
> > > 
> > > maxcpus=1 : core stays powered off
> > > 0 > online : core enters halt.
> > > 
> > > > I observed a funny behaviour of apache ant: although
> > > > it uses javac which is single threaded, a compile run
> > > > with "maxcpus=1" is actually faster than a compile run
> > > > with both cores activated. But with the second core
> > > > deactivated using "echo 0 >
> > > > /sys/devices/system/cpu/cpu1/online" it is even slower
> > > > than with both cores.
> > > 
> > > Thermal fun? Check cooling.
> > 
> > I have an extremely well cooled case and a Thermaltake Typhoon
> sitting
> > on the E6600 (Intel TDP 65 Watt). At a room temperature of 20°C
> both
> > cores idle at 21°C and after one hour of two instances of prime95
> > running they are both at 28-33°C. As the E6600 is specified until
> 60°C
> > (I believe), this should prevent any thermal throttling?
> 
> Ok, and your chip is too old to have "Enhanced Dynamic Acceleration
> Technology" (Intel, can't you use some reasonable names?!)... both
> would explain effects you see, and it is neither...

It is too old to have that. I bought it at the beginning of 2007 and it
is from the first line of Core 2 Duo processors (released in summer
2006). I think "Enhanced Dynamic Acceleration Technology" is only
available recently.

> You could try implementing deep sleep (C4) state for cpu hotplug....

I have to confess that I sneaked unto LKML illegitimately, as I am not
a kernel hacker.

But thank you all very much for all the hints!


      Lesen Sie Ihre E-Mails jetzt einfach von unterwegs.
www.yahoo.de/go

