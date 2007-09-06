Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbXIFJcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbXIFJcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXIFJcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:32:47 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1233 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbXIFJcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:32:46 -0400
Date: Thu, 6 Sep 2007 11:34:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add power meters to
 Documentation/hwmon/sysfs-interface
Message-ID: <20070906113429.1c88c844@hyperion.delvare>
In-Reply-To: <20070903232225.GD3899@khazad-dum.debian.net>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
	<20070828131942.18449886@hyperion.delvare>
	<20070828164440.GL32667@tree.beaverton.ibm.com>
	<20070901171048.GA3883@ucw.cz>
	<41840b750709011105s6c434217t50d965a0b17df643@mail.gmail.com>
	<20070901194417.GA24897@khazad-dum.debian.net>
	<20070902213837.7293d6fa@hyperion.delvare>
	<20070903020200.GA8948@khazad-dum.debian.net>
	<20070903180636.4096e7d5@hyperion.delvare>
	<20070903232225.GD3899@khazad-dum.debian.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007 20:22:25 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 03 Sep 2007, Jean Delvare wrote:
> > I see that the power supply class units are 10^-6 A and 10^-6 W, so if
> > we are supposed to be compatible, I guess we'll have to use this too.
> 
> There was a good reason for that, and people who deal with small portables
> said that they needed 10^-4 A or somesuch, at which point it makes more
> sense to just go to 10^-6 already.  I don't recall why 10^-6 W, though.

Well, if we need 10^-4 A, and we use voltages in the 1-2 V range
(that's what CPU, AGP etc. use these days), then we obviously need
10^-4 W as well.

-- 
Jean Delvare
