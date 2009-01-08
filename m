Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZAHIWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZAHIWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZAHIWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:22:15 -0500
Received: from mx1.auerswald.de ([212.185.163.234]:2621 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbZAHIWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:22:14 -0500
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver
Date: Thu, 8 Jan 2009 09:22:08 +0100
User-Agent: KMail/1.9.10
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
References: <20090106161006.GA28020@console-pimps.org>
In-Reply-To: <20090106161006.GA28020@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901080922.08773.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Dienstag, 6. Januar 2009 schrieb Matt Fleming:
> Which cards are you having issues with?

This was a noname 4 GByte SDHC card. If you write a continious stream of data 
at max. speed, the card generates a BUSY signal every 10 seconds for nearly a 
whole second.

> Modifying the code to no longer abide by the standard doesn't seem like a
> win to me.

I strongly disagree with you.

While each and every SD card should conform to the standard, a driver for a 
host controller should be as forgiving as possible. If the driver cannot cope 
with cards sold today, the user has a bad experience.

I code drivers for people and not for standards.

Remember, this is only a timeout. Lengthen the timeout will have no 
consequences for cards which behave.

best regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
