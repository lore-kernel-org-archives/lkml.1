Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZD0TD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZD0TD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZD0TDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:03:19 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:38932 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbZD0TDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:03:18 -0400
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome> <1240784454.22585.14.camel@localhost>
Message-ID: <cone.1240859015.836112.5316.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Mon, 27 Apr 2009 21:03:35 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

thanks for your email. A modified patch will follow soon.

>> + *  25-April-2009: Version 0.5:
>> + *  - ported to 2.6.30
>> + *  - removed kthread and used polling of thermal api
> 
> Version information in comments isn't generally useful

Will remove it.

> There's no other thermal device_mode state than ENABLED/DISABLED.
> Maybe just if/else?

Yes will do it.

>> +/* print the name of the trip point */
>> +static int get_trip_type(struct thermal_zone_device *thermal,
>> +		int trip, enum thermal_trip_type *type)
>> +{
>> +	if (trip == 0)
>> +		*type = THERMAL_TRIP_ACTIVE;
>> +	return 0;
>> +}
> 
> Comment doesn't match code.  I see no printing here.

Old comment, will correct it.

> You would #define pr_fmt(fmt) "acerhd: " fmt
> instead of prefixing all the printks with "acerhd:"

Jip, will do something like this.

kind regards,
--peter
