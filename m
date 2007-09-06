Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXIFQ3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXIFQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 12:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXIFQ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 12:29:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58922 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbXIFQ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 12:29:22 -0400
X-Sasl-enc: nntpPlaFOI4ZQtUk48CLpLpgw4gMz5lWX7kWIHUe2YVA 1189096161
Date: Thu, 6 Sep 2007 13:29:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add power meters to
	Documentation/hwmon/sysfs-interface
Message-ID: <20070906162917.GA1616@khazad-dum.debian.net>
References: <20070828131942.18449886@hyperion.delvare> <20070828164440.GL32667@tree.beaverton.ibm.com> <20070901171048.GA3883@ucw.cz> <41840b750709011105s6c434217t50d965a0b17df643@mail.gmail.com> <20070901194417.GA24897@khazad-dum.debian.net> <20070902213837.7293d6fa@hyperion.delvare> <20070903020200.GA8948@khazad-dum.debian.net> <20070903180636.4096e7d5@hyperion.delvare> <20070903232225.GD3899@khazad-dum.debian.net> <20070906113429.1c88c844@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906113429.1c88c844@hyperion.delvare>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007, Jean Delvare wrote:
> On Mon, 3 Sep 2007 20:22:25 -0300, Henrique de Moraes Holschuh wrote:
> > On Mon, 03 Sep 2007, Jean Delvare wrote:
> > > I see that the power supply class units are 10^-6 A and 10^-6 W, so if
> > > we are supposed to be compatible, I guess we'll have to use this too.
> > 
> > There was a good reason for that, and people who deal with small portables
> > said that they needed 10^-4 A or somesuch, at which point it makes more
> > sense to just go to 10^-6 already.  I don't recall why 10^-6 W, though.
> 
> Well, if we need 10^-4 A, and we use voltages in the 1-2 V range
> (that's what CPU, AGP etc. use these days), then we obviously need
> 10^-4 W as well.

I see, and in that case it is safer to just go to 10^-6 for both.  It is more
future-proof.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
