Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbXEGMwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbXEGMwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXEGMwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:52:39 -0400
Received: from khc.piap.pl ([195.187.100.11]:56528 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXEGMwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:52:38 -0400
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
References: <m3abwhcy74.fsf@maximus.localdomain>
	<m3y7k1biov.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705070343330.2733@scrub.home>
	<m3tzupc6wz.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705071318150.1479@scrub.home>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 07 May 2007 13:56:41 +0200
In-Reply-To: <Pine.LNX.4.64.0705071318150.1479@scrub.home> (Roman Zippel's message of "Mon, 7 May 2007 13:22:40 +0200 (CEST)")
Message-ID: <m3r6psc0ee.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel <zippel@linux-m68k.org> writes:

>> You don't have to know it's required, you can just select a driver
>> for your hardware, without enabling HDLC first.
>
> Is this a real problem?

I think the "select" is better.

> Using select you should also consider removing HDLC as visible option and 
> use only select. Mixing depends and selects is generally a bad idea.

It has to stay there for external modules.

It's similar to MII - drivers select MII automatically but you can
turn it on (Y or M) by hand as well.

And you can have HDLC=y and driver=m (and it makes perfect sense).

Actually I can't see any bad idea here.
The original dependency was certainly, uhm, not the best one.
-- 
Krzysztof Halasa
