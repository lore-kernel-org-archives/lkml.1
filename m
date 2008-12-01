Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYLAAFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYLAAFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYLAAFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:05:35 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56001 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbYLAAFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:05:35 -0500
Date: Mon, 1 Dec 2008 01:08:07 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] power_supply: Add cold to the POWER_SUPPLY_HEALTH
	report values
Message-ID: <20081201000806.GA3067@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081120152044.GA15434@rakim.wolfsonmicro.main> <1227194621-16442-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081125112512.GA1110@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125112512.GA1110@zarina>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 02:25:12PM +0300, Anton Vorontsov wrote:
> On Thu, Nov 20, 2008 at 03:23:40PM +0000, Mark Brown wrote:
> > Some systems are able to report problems with batteries being under
> > temperature.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Looks good to me.
> 
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
Thanks guys, both patches applied.

Cheers,
Samuel.
 
> > ---
> >  drivers/power/power_supply_sysfs.c |    2 +-
> >  include/linux/power_supply.h       |    1 +
> >  2 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> > index 23ae846..ac01e06 100644
> > --- a/drivers/power/power_supply_sysfs.c
> > +++ b/drivers/power/power_supply_sysfs.c
> > @@ -45,7 +45,7 @@ static ssize_t power_supply_show_property(struct device *dev,
> >  	};
> >  	static char *health_text[] = {
> >  		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
> > -		"Unspecified failure"
> > +		"Unspecified failure", "Cold",
> >  	};
> >  	static char *technology_text[] = {
> >  		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
> > diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> > index f9348cb..8ff25e0 100644
> > --- a/include/linux/power_supply.h
> > +++ b/include/linux/power_supply.h
> > @@ -45,6 +45,7 @@ enum {
> >  	POWER_SUPPLY_HEALTH_DEAD,
> >  	POWER_SUPPLY_HEALTH_OVERVOLTAGE,
> >  	POWER_SUPPLY_HEALTH_UNSPEC_FAILURE,
> > +	POWER_SUPPLY_HEALTH_COLD,
> >  };
> >  
> >  enum {
> > -- 
> > 1.5.6.5
> > 
> 
> -- 
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
