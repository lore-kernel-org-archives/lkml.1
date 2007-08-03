Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbXHCHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbXHCHqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXHCHqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:46:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60675 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXHCHqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:46:06 -0400
Date: Fri, 3 Aug 2007 09:46:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Michael Tokarev <mjt@tls.msk.ru>,
       Herbert Rosmanith <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <1186094979.3443.35.camel@lov.localdomain>
Message-ID: <Pine.LNX.4.64.0708030943250.495@fbirervta.pbzchgretzou.qr>
References: <200708021056.l72Au722008603@wildsau.enemy.org> 
 <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr> 
 <46B1D708.9040106@msgid.tls.msk.ru>  <Pine.LNX.4.64.0708021536350.24572@fbirervta.pbzchgretzou.qr>
  <Pine.LNX.4.64.0708022034190.9319@fbirervta.pbzchgretzou.qr> 
 <3ae72650708021500v3de84e6vdf15d0a9e5baf661@mail.gmail.com> 
 <Pine.LNX.4.64.0708030039300.495@fbirervta.pbzchgretzou.qr>
 <1186094979.3443.35.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3 2007 00:49, Kay Sievers wrote:
>> I think it is helpful to integrate the suse patch rather than to patch udev
>> alone. This way, renames that do not involve udev also show up.
>
>But if you need to swap interface names, you will see the useless
>temporary device names. On SUSE, nothing else renames network interfaces
>these days,

Yeah on SUSE on SUSE. The _user_ may very well swap these, either by using
/usr/sbin/ifrename (which is not even from udev!), or doing the magic himself
(ioctls, netlink, whatever is needed).

Also, it may happen that further things pop up during the two renames, e.g.

	eth0 renamed to ethxx0
	ethxx0: link up
	ethxx0 renamed to foo0

If only udev were to print it:

	eth0: RealTek 8139 whatever
	ethxx0: ink up
	eth0 renamed to foo0

and you think "what's ethxx0?".


	Jan
-- 
