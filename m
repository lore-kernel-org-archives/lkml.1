Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZCXOfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZCXOfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZCXOfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:35:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53082 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbZCXOe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:34:59 -0400
Date: Tue, 24 Mar 2009 15:33:03 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324143303.GP5367@pengutronix.de>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090324130202.GA32469@elte.hu>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 15:30:16 up 34 days,  6:23, 52 users,  load average: 12.18, 9.43,
	5.10
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 02:02:02PM +0100, Ingo Molnar wrote:
> If the box hung within 15 minutes, the kernel was deemed bad. Using 
> that method i arrived to this upstream networking fix which was 
> merged yesterday:
> 
>  | 303c6a0251852ecbdc5c15e466dcaff5971f7517 is first bad commit
>  | commit 303c6a0251852ecbdc5c15e466dcaff5971f7517
>  | Author: Herbert Xu <herbert@gondor.apana.org.au>
>  | Date:   Tue Mar 17 13:11:29 2009 -0700
>  |
>  |     gro: Fix legacy path napi_complete crash

This commit breaks nfsroot booting on i.MX27 and other ARM boxes with
different network cards here in a reproducable way.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
