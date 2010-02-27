Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251Ab0B0K00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:26:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36471 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965094Ab0B0K0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:26:22 -0500
Date: Sat, 27 Feb 2010 10:26:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Gardner <gardner.ben@gmail.com>, linux-kernel@vger.kernel.org,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Message-ID: <20100227102609.GA2994@sirena.org.uk>
References: <cover.1267225701.git.gardner.ben@gmail.com>
 <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
 <201002262302.18890.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002262302.18890.david-b@pacbell.net>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 11:02:18PM -0800, David Brownell wrote:
> On Friday 26 February 2010, Ben Gardner wrote:

> > Add 'none' and 'inout' directions to the sysfs interface.

> Both of those seem nonsensical:

>  "none" ... since it's not even a GPIO, why would it show
> 	up through the GPIO subsystem???

I suspect this is intended to be tristated, which might be useful to add.
