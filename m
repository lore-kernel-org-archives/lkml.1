Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbXFQCdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbXFQCdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 22:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXFQCc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 22:32:57 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38163
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXFQCcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 22:32:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: b44: high ping times with wireless-dev
Date: Sun, 17 Jun 2007 04:32:40 +0200
User-Agent: KMail/1.9.6
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Gary Zambrano <zambrano@broadcom.com>,
       "Jeff Garzik" <jgarzik@pobox.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
References: <200706162327.47413.maxi@daemonizer.de> <20070616154946.5fb6b013@localhost.localdomain> <200706170242.24214.maxi@daemonizer.de>
In-Reply-To: <200706170242.24214.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706170432.40958.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007 02:42:18 Maximilian Engelhardt wrote:
> I did build a kernel without the three mentioned above but the problem is 
> still the same. I also did remove everything but eth0 on interrupt 10 so the 
> only device using that interrupt is eth0 and then the card completely stopped 
> working.

_That_ is interesting...
Maybe the IRQ isn't correctly wired up on the backplane and
it doesn't generate IRQs at all (so it only worked, because other devices
on the same IRQ line triggered the line).
I'll take a look at that code.

-- 
Greetings Michael.
