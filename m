Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbXLUHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbXLUHrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbXLUHrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:47:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:39734 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750970AbXLUHrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:47:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/iY0xGQMfi+0zZ+MG8clNBJ0OqcYa8f9padRBoVw
	Rn+lYVwLQy5+sU
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
	well
From: Mike Galbraith <efault@gmx.de>
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200712201914.01103.volker.armin.hemmann@tu-clausthal.de>
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de>
	 <200712200653.28996.volker.armin.hemmann@tu-clausthal.de>
	 <1198134579.4429.10.camel@homer.simson.net>
	 <200712201914.01103.volker.armin.hemmann@tu-clausthal.de>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 08:47:16 +0100
Message-Id: <1198223236.3797.108.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 19:14 +0100, Hemmann, Volker Armin wrote:

> It is just.. I could be the hardware - but I should have seen the 
> same 'problem' with earlier kernels - and the 'almost daily oops' only 
> started with 2.6.23.

Nonetheless, the oopsen _suggest_ hardware.  If it were my box, I'd move
ram modules as a first step.  It costs about two minutes to eliminate
that possibility, but you seem reluctant to take that step.  Heck, I'd
_hope_ it's something as simple bad ram, because otherwise, quest for
stability could become a time consuming and/or expensive undertaking...

If that didn't change anything, I'd go back and stress test a previously
stable configuration to gain confidence in my hardware.  If 'uhoh, not
as stable as I thought' happened, and nothing is getting obviously hot
[1], I'd pray that it's an electrically noisy power supply, because
that's also easy and cheap.  In any case, once I was very very confident
that my hardware was indeed sound, I'd move on to an agonizingly tedious
bisection, with no out of tree modules ever loaded, to narrow down when
this memory corruption that nobody else appears to be hitting appeared.

	-Mike

1.  Crappy heatsink compound can dry out and fracture, leaving hot chip
under a relatively cool heatsink.  This is exactly what I found when I
disassembled my suddenly unstable under heavy load P4 box a while back.

