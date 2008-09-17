Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYIQPsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYIQPsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYIQPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:48:05 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45108 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbYIQPsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:48:04 -0400
Message-ID: <48D1269C.4060301@lwfinger.net>
Date: Wed, 17 Sep 2008 10:47:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Michael Buesch <mb@bu3sch.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
References: <48CFC03A.8020708@lwfinger.net> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org> <200809171622.55882.mb@bu3sch.de> <20080917145007.GA5186@khazad-dum.debian.net> <48D1221B.1000601@lwfinger.net> <20080917153637.GD5186@khazad-dum.debian.net>
In-Reply-To: <20080917153637.GD5186@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> Sorry, it can't fix that regression by itself, since b43 is not using
> rfkill_force_state() in mainline.
> 
> It will fix the same issue you are experiencing on b43 in anything that uses
> rfkill_force_state(), which means (for mainline): iwlwifi, rt2x00,
> thinkpad-acpi and hp-wmi.
> 
> It is a regression only on b43 and thinkpad-acpi, as the other drivers above
> didn't use rfkill_force_state() in 2.6.26.
> 
> To fix the regression in b43, you'd be faced with the need of both my simple
> patch AND Matthew's more complex one.

I don't expect that the more complex one will be accepted into 2.6.27.

Larry
