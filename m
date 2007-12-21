Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXLUMyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXLUMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXLUMyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:54:40 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:55230 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXLUMyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:54:40 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Fri, 21 Dec 2007 13:54:36 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712201914.01103.volker.armin.hemmann@tu-clausthal.de> <1198223236.3797.108.camel@homer.simson.net>
In-Reply-To: <1198223236.3797.108.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712211354.36460.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag, 21. Dezember 2007, Mike Galbraith wrote:
> On Thu, 2007-12-20 at 19:14 +0100, Hemmann, Volker Armin wrote:
> > It is just.. I could be the hardware - but I should have seen the
> > same 'problem' with earlier kernels - and the 'almost daily oops' only
> > started with 2.6.23.
>
> Nonetheless, the oopsen _suggest_ hardware.  If it were my box, I'd move
> ram modules as a first step.  It costs about two minutes to eliminate
> that possibility, but you seem reluctant to take that step.  Heck, I'd
> _hope_ it's something as simple bad ram, because otherwise, quest for
> stability could become a time consuming and/or expensive undertaking...
>

It costs a little bit more, but it will be part of the 'past holiday special'. 
As an intermediate step I incresed the voltages of the ram - looks good so 
far.

> If that didn't change anything, I'd go back and stress test a previously
> stable configuration to gain confidence in my hardware. 

you mean like playing ut2004 with reduced fans or several instances of 
cpuburn, or compiling something big like kdepim with kdeenablefinal? Done all 
that ...

> If 'uhoh, not 
> as stable as I thought' happened, and nothing is getting obviously hot
> [1], I'd pray that it's an electrically noisy power supply, because
> that's also easy and cheap. 

yeah, it would be the least annoying variant. After one PSU ate two computers, 
this one is just two and a half month old  -  I had my share of bad PSUs. 
That is why I increased the voltages. Maybe it helps.

> In any case, once I was very very confident 
> that my hardware was indeed sound, I'd move on to an agonizingly tedious
> bisection, with no out of tree modules ever loaded, to narrow down when
> this memory corruption that nobody else appears to be hitting appeared.
>
> 	-Mike
>
> 1.  Crappy heatsink compound can dry out and fracture, leaving hot chip
> under a relatively cool heatsink.  This is exactly what I found when I
> disassembled my suddenly unstable under heavy load P4 box a while back.

still this would show up with the temps. And the temps are ok.

Glück Auf,
Volker
