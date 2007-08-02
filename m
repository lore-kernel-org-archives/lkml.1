Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXHBKod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXHBKod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXHBKo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:44:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34980 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbXHBKoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:44:25 -0400
Date: Thu, 2 Aug 2007 12:44:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Herbert Rosmanith <kernel@wildsau.enemy.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <200708021020.l72AKvjC008561@wildsau.enemy.org>
Message-ID: <Pine.LNX.4.64.0708021242590.24572@fbirervta.pbzchgretzou.qr>
References: <200708021020.l72AKvjC008561@wildsau.enemy.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 12:20, Herbert Rosmanith wrote:
>
>I see a strange numbering of ethernet devices with a VIA EPIA EK
>board. This board has two ethernet connectors, you can see it
>here: http://www.via.com.tw/en/products/mainboards/motherboards.jsp?motherboard_id=420

Maybe udev is configured to do renaming on the interfaces?

>an "ifconfig eth"0(eth1) will report:

Hence use `ip a`.

>pretty strange?! I dont think this is the correct behaviour, is it?

No, not strange at all. At least openSUSE ensures (or TRIES - there
are _really_ broken chips out there that change their MAC every boot)
that each card has the same interface name regardless of load order etc.




	Jan
-- 
