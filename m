Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXIBTh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXIBTh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIBThT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:37:19 -0400
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:4092 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbXIBThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:37:17 -0400
Date: Sun, 2 Sep 2007 21:38:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add power meters to
 Documentation/hwmon/sysfs-interface
Message-ID: <20070902213837.7293d6fa@hyperion.delvare>
In-Reply-To: <20070901194417.GA24897@khazad-dum.debian.net>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
	<20070828131942.18449886@hyperion.delvare>
	<20070828164440.GL32667@tree.beaverton.ibm.com>
	<20070901171048.GA3883@ucw.cz>
	<41840b750709011105s6c434217t50d965a0b17df643@mail.gmail.com>
	<20070901194417.GA24897@khazad-dum.debian.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007 16:44:17 -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 01 Sep 2007, Shem Multinymous wrote:
> > > Should we add power?_10sec_avg_input? IIRC thinkpads export that,
> > > too.
> 
> I'd say it is enough to know it is an average, you don't need to specify HOW
> it is averaged.

Agreed.

> But there is a real need to export both instantaneous and averaged values in
> power supplies/power sources, so we should have a standard way to do so in
> hwmon, and power_supply class should use it (or the opposite, it doesn't
> matter, as long as everyone does it the same way).

I guess power[1-*]_average would be OK?

-- 
Jean Delvare
