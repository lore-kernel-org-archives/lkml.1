Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0CDPK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:10:59 -0500
Received: from senator.holtmann.net ([87.106.208.187]:55561 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0CDPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:10:58 -0500
Subject: Re: Linux Bluetooth Coexistence documentation in general and for
 ath9k
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Kevin Hayes\" <kevin@atheros.com>, \"Dan Tian\"" 
	<Dan.Tian@atheros.com>
In-Reply-To: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com>
References: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 07:10:51 -0800
Message-ID: <1267715451.29510.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> The question of Bluetooth coexistence pops up here, on IRC and on bug
> reports quite too often so I've stuffed what I could onto a page with
> a few references / code and about ath9k's schemes for BT coexistence,
> feel free to extend or correct:
> 
> http://wireless.kernel.org/en/users/Documentation/Bluetooth-coexistence
> http://wireless.kernel.org/en/users/Drivers/ath9k/btcoex
> 
> I'm still not sure if "2-wire" and "3-wire" are generic terms and if
> someone owns a trademark on them or what, but looking down the road I
> think it would be nice to export this information through nl80211, if
> a device supports any of these BT-coex schemes and if so, perhaps
> display the current signal status of:
> 
>   * WLAN_ACTIVE
>   * BT_PRIORITY
>   * BT_STATE
> 
> I do wonder if this could be useful to network applets like network
> manager/connman. The other BT coex schemes are BT specific it seems
> and not sure if those devices can expose that information out and
> inform userspace of certain events.
> 
> Marcel, does the BlueZ support exporting if certain bt-coex schemes
> are supported like AFH, channel skipping, TDM, and also if they are
> being used and details of that?

the only thing the host has control over is AFH channel map, and even
modifying that is not really needed. The Bluetooth controller will do
AFH automatically and it is on by default. We never switch that off
actually.

Normally the co-ex stuff is hard-wired between the Bluetooth and WiFi
and thus out of control to the host OS.

Regards

Marcel


