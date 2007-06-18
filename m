Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbXFRRAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbXFRRAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbXFRRAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:00:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:41412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757552AbXFRRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:00:29 -0400
X-Authenticated: #441233
X-Provags-ID: V01U2FsdGVkX18qkel0+xgqkRvIlGDOnz4c6xS0N2PfGvZOMT09gN
	K7SCVmPbyzb89o
Date: Mon, 18 Jun 2007 19:00:27 +0200
From: Michael Mauch <michael.mauch@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Stable identification of identical USB hardware
Message-ID: <20070618170027.GA11233@elmicha>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <157636.91774.qm@web51404.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157636.91774.qm@web51404.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Pommnitz wrote:

> I want to be able to distinguish between two (or more) mostly
> identical USB serial devices. The devices in question are UMTS modems.
> AFAIK they are identical except for the SIM card and the point of
> attachment. Externally the cards are CardBus devices with an integrated
> USB host adapter. The actual UMTS device is (internally) connected to
> the USB host adapter.

> If I have to cardbus sockets, how do I get from what I know ("the card
> is in socket 0") to "I have to talk to ttyUSB2 to talk to the card"? I
> suspect I have to follow the thread from /sys/bus/pci to
> /sys/bus/usb/devices, but how exactly?

You should be able to distinguish the devices with udev. Have a look at
http://www.reactivated.net/writing_udev_rules.html 

If that doesn't help, I would like to propose that you ask again in
the de.comp.os.unix.linux.hardware or comp.os.linux.hardware newsgroups.

Regards...
		Michael

