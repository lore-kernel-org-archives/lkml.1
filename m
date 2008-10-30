Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbYJ3Tz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbYJ3Tz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJ3Tzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:55:49 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:3485 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751035AbYJ3Tzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:55:48 -0400
Date: Thu, 30 Oct 2008 22:55:46 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/3 RFC] MMC SPI support for OpenFirmware platforms
Message-ID: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are the bindings, again. Still RFC.

This patch series depends on:
http://lkml.org/lkml/2008/10/16/250
http://lkml.org/lkml/2008/10/24/416 
+ of_gpio_flags enum (Trent Piepho will post an updated patch soon,
I believe).

Pierre, the approach is somewhat similar to this one:
http://lkml.org/lkml/2008/5/26/135
Posted few months ago.

I know you don't like it, but I ask you to reconsider it. The
I2C and SPI cases are similar, and recently we tried to write
bindings for some I2C GPIO controllers.

There we've learned that we:

1. Don't like the bus notifiers approach b/c we can't place the OF
   code into the module.
   http://lkml.org/lkml/2008/10/21/425
   Hacks are possible, but they're are ugly.
2. Don't want to write new drivers to solely handle the platform
   data:
   http://lkml.org/lkml/2008/10/28/257
   http://lkml.org/lkml/2008/10/28/268

And personally I don't want to do refactoring for every driver that
we'd want to use with the OpenFirmware...

If I understood correctly, for GPIO controllers David agreed that
we can live with the platform data accessors, at least for now:
http://lkml.org/lkml/2008/10/23/24

And when/if we'll find something better I'll be the first who
will offer help to convert the bindings code to this "something
better".

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
