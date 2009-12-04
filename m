Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZLDKtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZLDKtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZLDKta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:49:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46856 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZLDKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:49:30 -0500
Date: Fri, 4 Dec 2009 10:49:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: cbou@mai.ru, dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091204104930.GA28625@sirena.org.uk>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
X-Cookie: Courage is grace under pressure.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:42:22AM +0100, Linus Walleij wrote:

> Most devices of this kind does not need the stuff we're doing so we're
> the odd bird here. Other batteries are "smart" (contain factory
> calibration inside of them) or get calibration from some BIOS or such.

> In our code we have a number of (x,y) pair tables like this:

> /* Vbat mV to Battery capacity % */
> struct voltage_vs_capacity {
> 	int voltage;
> 	int capacity;
> };

Isn't the standard thing here to handle this voltage to capacity mapping
in userspace if we're just extrapolating from experimental results?
Even with the "smart" batteries in PCs there are some accuracy concerns
and obviously the performance of the battery will change over time.
