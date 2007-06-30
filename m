Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbXF3Vyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbXF3Vyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 17:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbXF3VyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 17:54:11 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39508
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbXF3VyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 17:54:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "=?iso-8859-1?q?T=F6r=F6k?= Edvin" <edwintorok@gmail.com>
Subject: Re: [PATCH] b44: power down PHY when interface down
Date: Sat, 30 Jun 2007 23:53:25 +0200
User-Agent: KMail/1.9.6
Cc: zambrano@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, power@bughost.org
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com>
In-Reply-To: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706302353.25426.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2007 13:47:35 Török Edvin wrote:
> When the interface is down (or driver removed), the BroadCom 44xx card remains
> powered on, and both its MAC and PHY is using up power.
> This patch makes the driver issue a MAC_CTRL_PHY_PDOWN when the interface
> is halted, and does a partial chip reset turns off the activity LEDs too.
> 
> Applies to 2.6.22-rc6, or current git head.
> 
> Tested on a Broadcom BCM4401-B0 card, it saves ~0.5W (measured using powertop).

Hm, I was going to measure the real power advantage with a
PCI-extender card. But my B44B0 card doesn't seem to work in
that extender card. It works perfectly fine sticked directly into
the motherboard, though, and other cards like a BCM4318 work in
the extender, too.
Not sure what this is.
The extender has an application note about nonworking cards in the
extender and a too big resistor on the board IDSEL pin being the
cause of this.
Maybe I can try with another machine tomorrow.

-- 
Greetings Michael.
