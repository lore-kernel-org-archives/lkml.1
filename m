Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbYBATQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbYBATQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbYBATPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:15:43 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:45992 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068AbYBATPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:15:42 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: kernel panic on 2.6.24/iTCO_wdt not rebooting machine
Date: Fri, 1 Feb 2008 21:15:07 +0200
Message-Id: <20080201191048.M59862@visp.net.lb>
In-Reply-To: <200802011211.42089.lenb@kernel.org>
References: <20080201151243.M2879@visp.net.lb> <200802011211.42089.lenb@kernel.org>
X-Mailer: OpenWebMail 2.52 
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 Feb 2008 12:11:41 -0500, Len Brown wrote
> 
> What do you see if you build with CONFIG_HIGH_RES_TIMERS=n
> 
> Does it work better if you boot with "acpi=off"?
> if yes, how about with just pnpacpi=off?
> 
> thanks,
> -Len

It is not very easy to test. About bug - most probably it is related to third 
party ESFQ patch, i will drop it and then test more properly when i will be 
able to make watchdog work fine. But more important i notice - that iTCO_wdt 
is not working at all. I think hrtimers doesn't change anything on that.
About testing, i cannot take even small risk now(and near 3-5 days) by 
changing kernel options, i set now maximum available set of watchdogs, cause 
there is noone to maintain server, area is unreachable because of snow and 
bad weather.

Do you think reasonable to try acpi / pnpacpi with iTCO_wdt to make it work? 
Maybe just registers addresses or way how TCO watchdog activated changed on 
this chipset?


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

