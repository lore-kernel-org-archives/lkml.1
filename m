Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0CDAtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:49:12 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63445 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0CDAtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=tWtntjqVlrqIGbchmKy4wr/xdXS2eAZOsHNPlXJ2bnKB6sQEp7ShHPwZ2rNLIZBHXP
         K2vtNE81zWbcgHHvz3u8T1oZ2ZtbfOl/4vaRswmUboGlBWTK84VUcJJKJsc6IyTWn4Cw
         Vtzr3O0rtuN4nfDMp2v07nNGvIXs30JAI1ZM4=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 3 Mar 2010 16:43:37 -0800
Message-ID: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com>
Subject: Linux Bluetooth Coexistence documentation in general and for ath9k
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Kevin Hayes\" <kevin@atheros.com>, \"Dan Tian\"" 
	<Dan.Tian@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel, a question for you below.

The question of Bluetooth coexistence pops up here, on IRC and on bug
reports quite too often so I've stuffed what I could onto a page with
a few references / code and about ath9k's schemes for BT coexistence,
feel free to extend or correct:

http://wireless.kernel.org/en/users/Documentation/Bluetooth-coexistence
http://wireless.kernel.org/en/users/Drivers/ath9k/btcoex

I'm still not sure if "2-wire" and "3-wire" are generic terms and if
someone owns a trademark on them or what, but looking down the road I
think it would be nice to export this information through nl80211, if
a device supports any of these BT-coex schemes and if so, perhaps
display the current signal status of:

  * WLAN_ACTIVE
  * BT_PRIORITY
  * BT_STATE

I do wonder if this could be useful to network applets like network
manager/connman. The other BT coex schemes are BT specific it seems
and not sure if those devices can expose that information out and
inform userspace of certain events.

Marcel, does the BlueZ support exporting if certain bt-coex schemes
are supported like AFH, channel skipping, TDM, and also if they are
being used and details of that?

  Luis
