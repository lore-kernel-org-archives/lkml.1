Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbZD1WLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbZD1WLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZD1WL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:11:29 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:45435 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754603AbZD1WL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:11:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=d7dCCeTnECQ232kUohEk0f2yPI+6SCtdueTWVu/EL22TG+k+JyVjhc5kmA7gpXVFWDds7SkhF2BvC+btdhrReBLWRSetAfw+98fc3bkBOv/CXdQfR/+9hy8p92MYeK4gDdFjbEAHkCMd84jy831FvaXi+JBerKfYAMYuCF61O9k=  ;
X-YMail-OSG: vBtPOcEVM1noMsT71TAccGxABF7YzCJ1jGzo_J.v5XuuAzF64s333e8Q6QDTQ8ry8Bz6KdHDmCBKsCUnD2hG96LBeOh0bTBjirgXKicvwU7aZOtnS87dIoowTLZY.BZR1ZoPgoWatoB9vVsIVMr7xYKgnTJdHzIybD_GI9NyW5l0r6j9mZva_uJtKTH_iEAvXe8992KU6oM9vf33p1fPHwEz8hm1cGAxCCuhHORxV6kKg3LBPUxZYPPZcMnjxk6ThmZUtBmiwt44V_3IiX0YC6n9MpcgbyZ49aFqgLKkEvQDgH6ZePzf
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] make mmci-omap using platform_driver_probe
Date: Tue, 28 Apr 2009 15:11:26 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>,
       Tony Lindgren <tony@atomide.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903280927.32786.david-b@pacbell.net> <1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090428212714.3c9bbc3d@mjolnir.ossman.eu>
In-Reply-To: <20090428212714.3c9bbc3d@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904281511.26608.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Pierre Ossman wrote:
> > 
> > As requested by David Brownell platform_driver_probe is used instead of
> > moving the probe function to .devinit.text.  This saves some memory, but
> > might have the downside that a device being registered after the call to
> > mmc_omap_init but before the init sections are discarded will not be
> > bound anymore to the driver.

However, as I noted that *does not happen* ... so, no worries.

