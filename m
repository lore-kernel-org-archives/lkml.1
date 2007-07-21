Return-Path: <linux-kernel-owner+w=401wt.eu-S934183AbXGUH3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183AbXGUH3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 03:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbXGUH3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 03:29:43 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:60895 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171AbXGUH3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 03:29:42 -0400
Date: Sat, 21 Jul 2007 09:29:30 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, tonyko@lineo.ca,
       robin.getz@analog.com, linux-kernel@vger.kernel.org
Subject: Re: blackfin - cmpxchg not atomic ?
Message-ID: <20070721072930.GS1678@pengutronix.de>
References: <20070720202807.GA15009@Krystal> <8bd0f97a0707201336l6bed7c24i7014333ce356417f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707201336l6bed7c24i7014333ce356417f@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 04:36:12PM -0400, Mike Frysinger wrote:
> > Also, does you assembly stub _really_ modify memory atomically ? If yes,
> > then there should be no need for disabling interrupts. Else, I see a
> > major problem with SMP.
> 
> that isnt the only problem with SMP on Blackfin

Could you ealborate?

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

