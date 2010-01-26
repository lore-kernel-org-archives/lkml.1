Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573Ab0AZQeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0AZQeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108Ab0AZQeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:34:13 -0500
Received: from bamako.nerim.net ([62.4.17.28]:62491 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0AZQeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:34:12 -0500
Date: Tue, 26 Jan 2010 17:34:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add i2c tree for embedded platforms
Message-ID: <20100126173409.54f32259@hyperion.delvare>
In-Reply-To: <20100126153759.GF4431@pengutronix.de>
References: <1264411234-5400-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20100125111055.05ccedf2@hyperion.delvare>
	<20100126143830.GC12774@fluff.org.uk>
	<20100126162515.230bdf36@hyperion.delvare>
	<20100126153759.GF4431@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 16:37:59 +0100, Wolfram Sang wrote:
> > So I see no objection to a mass move of all embedded/system i2c bus
> > drivers to a separate sub-directory.
> 
> And with the PCA9xxx-controllers? The ISA-driver into non-embedded and the
> platform-driver into embedded? Hmmm...

Ideally the ISA driver would go to the trash can ;) and having both on
separate directories doesn't strike me as being a problem. We have
i2c-algo-bit-based drivers in many places and this has never been a
problem.

> And (in 80 years ;)) there might be just one I2C-maintainer taking care of them
> all? Then, why the split?

That's a more valid argument. But then again, MAINTAINERS can be edited
again later as needed, with split entries getting merged or the other
way around. What matters is that MAINTAINERS reflects the reality of
who is doing what.

> I am all for taking the embedded-burden away from you, just I am not too fond
> of this idea.

I'm not forcing anyone, and I would welcome alternative solutions.

-- 
Jean Delvare
