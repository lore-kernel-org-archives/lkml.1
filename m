Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZLDORb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZLDORb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZLDOR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:17:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42749 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbZLDOR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:17:28 -0500
Date: Fri, 4 Dec 2009 14:17:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: cbou@mai.ru, dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091204141731.GA5668@sirena.org.uk>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se> <20091204104930.GA28625@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204104930.GA28625@sirena.org.uk>
X-Cookie: A bachelor is an unaltared male.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 10:49:31AM +0000, Mark Brown wrote:

> Isn't the standard thing here to handle this voltage to capacity mapping
> in userspace if we're just extrapolating from experimental results?
> Even with the "smart" batteries in PCs there are some accuracy concerns
> and obviously the performance of the battery will change over time.

Actually, one further thing here - if this functionality is implemented
in kernel then shouldn't it be a generic feature rather than part of the
driver?  The idea of mapping battery voltages to capacity percentages
isn't specific to a given charger and will apply to all batteries using
the same technology.
