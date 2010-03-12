Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0CLICe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:02:34 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39723 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab0CLICd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:02:33 -0500
Date: Fri, 12 Mar 2010 10:02:16 +0200
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       =?utf-8?B?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, devel@driverdev.osuosl.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: cfg80211 conversion of all drivers
Message-ID: <20100312080216.GA18550@jm.kir.nu>
References: <43e72e891003111722n4b4d5b6crf764dfe357ff8965@mail.gmail.com>
 <69e28c911003111756h224ef6a9x622c979232b6698b@mail.gmail.com>
 <20100312025330.GA15402@tuxdriver.com>
 <201003120810.38194.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003120810.38194.holgerschurig@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 08:10:37AM +0100, Holger Schurig wrote:
> > I think that is code for "replace it with something based on mac80211"...
> 
> That's not going to happen, hostap + orinoco both work against fullmac chips, 
> which can't send arbitrary packets and therefore no 802.11 management frames.

The Host AP mode in Prism 2/2.5/3 provides for a somewhat special
situation.. It does actually allow sending of (almost) arbitrary packets
and management frames in AP mode. In other words, it should be possible
to create a mac80211-based AP mode driver for Prism 2/2.5/3 to replace
the AP side of the Host AP driver. Whether anyone has enough interest
and time to do that is another question, though.

As far as station functionality is concerned, I would agree that
mac80211 is not a good target for the Host AP driver. If AP side were to
be made available as a mac80211-based driver, it could make more sense
to merge station side from the Host AP driver into orinoco or some kind
of combination of the driver. However, having two different drivers for
same hardware issue would not go anywhere with this.

One of the problems here is that the hardware is question is quite old
and for many practical purposes obsolete, so finding people to work on
this can get difficult. I can certainly come up with much better uses
for my time.. ;-)
 
-- 
Jouni Malinen                                            PGP id EFC895FA
