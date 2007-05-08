Return-Path: <linux-kernel-owner+w=401wt.eu-S967085AbXEHMrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967085AbXEHMrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966951AbXEHMrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:47:09 -0400
Received: from tim.rpsys.net ([194.106.48.114]:51033 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967008AbXEHMrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:47:08 -0400
Subject: Re: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
From: Richard Purdie <rpurdie@rpsys.net>
To: kogiidena@eggplant.ddo.jp
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp>
References: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp>
Content-Type: text/plain
Date: Tue, 08 May 2007 13:46:47 +0100
Message-Id: <1178628407.6061.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 21:27 +0900, kogiidena wrote:
> I wrote LED Blink Trigger. Pleas apply if there is no problem.
> 
> This allows LEDs to be controlled by a programmable timer.
> "blink" blinks LED at a constant cycle.
> "bitshift" turns LED or Buzzer on and off by the value of pattern.
> 
> Kernel version: linux-2.6.21-rc4
> Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>

As far as I can tell, the existing timer trigger can do everything the
blink trigger can (and more besides). The driver looks like it would be
a lot easier to read if it just contained the bitshift trigger. To be
accepted, the bitshift trigger needs more documentation, particularly
the Kconfig entry. Its not clear for example that the bits are just
shifted once and don't repeat. Most people would probably want it to
repeat and with a repeat mode, it might be able to replace the heartbeat
trigger too?

Regards,

Richard




