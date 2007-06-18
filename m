Return-Path: <linux-kernel-owner+w=401wt.eu-S1764369AbXFRPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764369AbXFRPmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762651AbXFRPmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:42:18 -0400
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:24373 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756169AbXFRPmR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:42:17 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 11:42:17 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nL39A2xObPtBRH4JPTVHYWuhsZs1jY1tjaXK8E+4/66Mf9lS+lfvQlmMjiposp/OWwB//M3i/iSw1UY2t2XZpwOZnDeRGPBYdYoCkchrzQXQ56CIJSCRFKX90XKvHwrATvVKoqevDbAbquUFIrtVZQS6I9+lQ3APrtmEuD95xUc=;
X-YMail-OSG: AXXY63YVM1me8ASAUOBl0q2.0iyJ7keRDs7jjtm9LC8ZMkktWC4KkDuUbw2YPVgY66yFJZmhnWYL03jTbrqQQlYbrzMb6dghT40sepZk7pWeFXb08fk6sodPWDwELw--
X-Mailer: YahooMailRC/651.29 YahooMailWebService/0.7.41.16
Date: Mon, 18 Jun 2007 08:35:35 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Stable identification of identical USB hardware
To: linux-kernel@vger.kernel.org, linux-usb-users@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <157636.91774.qm@web51404.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I want to be able to distinguish between two (or more) mostly identical USB serial devices. The devices in question are UMTS modems. AFAIK they are identical except for the SIM card and the point of attachment. Externally the cards are CardBus devices with an integrated USB host adapter. The actual UMTS device is (internally) connected to the USB host adapter.

If I have to cardbus sockets, how do I get from what I know ("the card is in socket 0") to "I have to talk to ttyUSB2 to talk to the card"? I suspect I have to follow the thread from /sys/bus/pci to /sys/bus/usb/devices, but how exactly?

Thanks in advance and kind regards
  Joerg

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
