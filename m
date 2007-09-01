Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXIAToe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXIAToe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbXIAToZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:44:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56428 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755341AbXIAToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:44:24 -0400
X-Sasl-enc: uj8D1/h49VoC+P5H8ArJkGtPuqN70CLMhHF1CVNGat1Q 1188675861
Date: Sat, 1 Sep 2007 16:44:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shem Multinymous <multinymous@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add power meters to
	Documentation/hwmon/sysfs-interface
Message-ID: <20070901194417.GA24897@khazad-dum.debian.net>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164440.GL32667@tree.beaverton.ibm.com> <20070901171048.GA3883@ucw.cz> <41840b750709011105s6c434217t50d965a0b17df643@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41840b750709011105s6c434217t50d965a0b17df643@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Sep 2007, Shem Multinymous wrote:
> > Should we add power?_10sec_avg_input? IIRC thinkpads export that,
> > too.

I'd say it is enough to know it is an average, you don't need to specify HOW
it is averaged.

But there is a real need to export both instantaneous and averaged values in
power supplies/power sources, so we should have a standard way to do so in
hwmon, and power_supply class should use it (or the opposite, it doesn't
matter, as long as everyone does it the same way).

> It would be nice if the power meter interface uses the same
> conventions as the power supply interface, since the former is
> essentially a subset of the latter. Userspace app that read power
> meters via sysfs should work for power supplies too.

Agreed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
