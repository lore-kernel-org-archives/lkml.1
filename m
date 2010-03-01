Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab0CAKxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:53:38 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41915 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab0CAKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:53:35 -0500
Date: Mon, 1 Mar 2010 12:53:29 +0200
From: Jouni Malinen <j@w1.fi>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Problem with bridges and wireless NIC's
Message-ID: <20100301105329.GA2684@jm.kir.nu>
References: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
 <20100301075953.GA32038@jm.kir.nu>
 <9c30dffe1003010012l5b3a912fma5655e630b83ce9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c30dffe1003010012l5b3a912fma5655e630b83ce9f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 09:12:48AM +0100, Bjarke Istrup Pedersen wrote:
> That sounds interresting, is there any chance that that functionality
> can be added to the 0.6.x branch too? (I'm maintaining hostapd in
> Gentoo, but cannot stabilize a 0.7.x build, due to it being a
> development branch)

While it might be relatively simple to port the bridge setup code into
0.6.x, I'm not that keen on doing it for this particular reason. I'm
recommending 0.7.x branch for all AP functionality with nl80211-based
driver interface and as such, do not really want to promote use of 0.6.x
versions for this.

I started working on porting the driver_nl80211.c changes into the 0.6.x
branch, but that turned up to take way too much effort compared to what
the potential benefit would be. As such, I do not plan on continuing on
this direction and you should be prepared to quite a bit of additional
work on porting non-trivial fixes from hostapd 0.7.x yourself if you
plan on using hostapd 0.6.x in Gentoo with mac80211/nl80211-based
drivers.

-- 
Jouni Malinen                                            PGP id EFC895FA
