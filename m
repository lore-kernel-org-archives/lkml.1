Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab0CJUwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:52:32 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35498 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757120Ab0CJUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:52:30 -0500
Date: Wed, 10 Mar 2010 21:48:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Kevin Hayes <kevin@atheros.com>, Dan Tian" <Dan.Tian@atheros.com>
Subject: Re: Linux Bluetooth Coexistence documentation in general and for
	ath9k
Message-ID: <20100310204818.GF1394@ucw.cz>
References: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com> <1267715451.29510.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267715451.29510.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The question of Bluetooth coexistence pops up here, on IRC and on bug
> > reports quite too often so I've stuffed what I could onto a page with
> > a few references / code and about ath9k's schemes for BT coexistence,
> > feel free to extend or correct:
> > 
> > http://wireless.kernel.org/en/users/Documentation/Bluetooth-coexistence
> > http://wireless.kernel.org/en/users/Drivers/ath9k/btcoex
> > 
> > I'm still not sure if "2-wire" and "3-wire" are generic terms and if
> > someone owns a trademark on them or what, but looking down the road I
> > think it would be nice to export this information through nl80211, if
> > a device supports any of these BT-coex schemes and if so, perhaps
> > display the current signal status of:
> > 
> >   * WLAN_ACTIVE
> >   * BT_PRIORITY
> >   * BT_STATE
...
> the only thing the host has control over is AFH channel map, and even
> modifying that is not really needed. The Bluetooth controller will do
> AFH automatically and it is on by default. We never switch that off
> actually.
> 
> Normally the co-ex stuff is hard-wired between the Bluetooth and WiFi
> and thus out of control to the host OS.

I believe that 'internal wifi, usb bluetooth' is still quite common
setup...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
