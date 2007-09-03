Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbXICXWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbXICXWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 19:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXICXWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 19:22:30 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55482 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbXICXW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 19:22:29 -0400
X-Sasl-enc: 7NnC3sMGMWUN6TPldyeKcBpqTEk8P294J774hEbozs5K 1188861748
Date: Mon, 3 Sep 2007 20:22:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add power meters to
	Documentation/hwmon/sysfs-interface
Message-ID: <20070903232225.GD3899@khazad-dum.debian.net>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164440.GL32667@tree.beaverton.ibm.com> <20070901171048.GA3883@ucw.cz> <41840b750709011105s6c434217t50d965a0b17df643@mail.gmail.com> <20070901194417.GA24897@khazad-dum.debian.net> <20070902213837.7293d6fa@hyperion.delvare> <20070903020200.GA8948@khazad-dum.debian.net> <20070903180636.4096e7d5@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903180636.4096e7d5@hyperion.delvare>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Sep 2007, Jean Delvare wrote:
> On Sun, 2 Sep 2007 23:02:01 -0300, Henrique de Moraes Holschuh wrote:
> > On Sun, 02 Sep 2007, Jean Delvare wrote:
> > > I guess power[1-*]_average would be OK?
> > 
> > AFAIK, yes.  It is probably not 100% in sync with the power supply class,
> > though.
> 
> Is the power supply class creating sysfs files? I see a number of
> attributes listed in Documentation/power_supply_class.txt, but they are
> all uppercase, which doesn't seem suitable for sysfs file names. That
> document also doesn't list the numbering convention when multiple
> channels are present.

Looks like power supply needs some tweaks, then.

> My main worry is that we will have to add support for power measurement
> in libsensors, and I would like it to be as easy as possible. Thus
> sticking to the same naming convention hwmon have been using for years
> appears to be the best solution.

Agreed.

> I see that the power supply class units are 10^-6 A and 10^-6 W, so if
> we are supposed to be compatible, I guess we'll have to use this too.

There was a good reason for that, and people who deal with small portables
said that they needed 10^-4 A or somesuch, at which point it makes more
sense to just go to 10^-6 already.  I don't recall why 10^-6 W, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
