Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZAHKjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZAHKjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAHKjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:39:23 -0500
Received: from fw2.winet.de ([84.17.96.48]:56993 "EHLO fw2.winet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZAHKjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:39:22 -0500
X-Greylist: delayed 1211 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 05:39:22 EST
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver
Date: Thu, 8 Jan 2009 11:19:00 +0100
User-Agent: KMail/1.9.10
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, "Pierre Ossman" <drzeus@drzeus.cx>
References: <20090108092407.GA6108@console-pimps.org>
In-Reply-To: <20090108092407.GA6108@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901081119.00812.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Donnerstag, 8. Januar 2009 schrieb Matt Fleming:
> My concern is that completely broken cards may be able to get away with
> more if the timeout is extended.

Ah, and you think that the failure of these cards in some embedded devices 
will push the vendors of these cards to fix their bugs?

Sorry, I don't think so. If this driver will run in more than 50% of all SD 
card devices: yes. But in reality, it will be below 1%...

> There is clearly a tradeoff here between supporting non-conforming cards 
> and easily detecting broken cards. 

IMHO, not supporting a non-conforming card (if you CAN) is ignorance. 
Ignorance to the user, which you leave alone with her problems.

> Someone suggested to me off list that having a configuration option to
> enable/disable the longer timeout is a good compromise, and I agree.

I don't see value in this compromise. The person which is able to turn the 
configuration option will be != the user of the device and != the owner of 
the card. 

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
