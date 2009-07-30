Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZG3KAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZG3KAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZG3KAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:00:08 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:37552 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZG3KAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:00:07 -0400
Message-ID: <4A716F1C.2050805@mnementh.co.uk>
Date: Thu, 30 Jul 2009 10:59:56 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: pHilipp Zabel <philipp.zabel@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>	 <20090729115817.GA12223@rakim.wolfsonmicro.main>	 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>	 <20090729124233.GA12802@rakim.wolfsonmicro.main>	 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>	 <4A704777.70001@mnementh.co.uk>	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>	 <4A7053E8.8050303@mnementh.co.uk>	 <20090729201702.GA28202@linux-sh.org> <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
In-Reply-To: <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I've spent some time thinking on this.

There is _no_ clean solution at present and Im not happy with having 
more than one clocking system co-existing in the mmc driver.

I will produce a patch to  completely remove all clocking and power 
control from the driver and make it use callbacks in order to achieve 
this. This will leave us with a clean driver that will be simple to 
adapt to the clock API.

I wont have time to work on it until next week, however, so if anyone 
wants to take a stab at it in the meantime, feel free to do so, and I'll 
review it next week.

-Ian
