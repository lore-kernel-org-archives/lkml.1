Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZDZLsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZDZLsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZDZLrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:47:53 -0400
Received: from cathcart.site5.com ([74.54.107.137]:56185 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZDZLrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:47:52 -0400
Message-ID: <49F449B8.2010707@compulab.co.il>
Date: Sun, 26 Apr 2009 14:47:04 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: add userspace-consumer driver
References: <cover.1240736991.git.mike@compulab.co.il> <f9c42ab0212ead9b7edac2d39f7848c46ad527d5.1240736991.git.mike@compulab.co.il> <20090426100211.GC9009@opensource.wolfsonmicro.com>
In-Reply-To: <20090426100211.GC9009@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mark Brown wrote:
> On Sun, Apr 26, 2009 at 12:17:23PM +0300, Mike Rapoport wrote:
> 
>> +/*
>> + * line-consumer.c
> 
> Bitrot.

Thanks, I'll fix it.

> 
>> +	for (i = 0; i < drvdata->num_supplies; i++)
>> +		drvdata->supplies[i].supply = pdata->supplies[i].supply;
> 
> ...
> 
>> +struct regulator_userspace_consumer_data {
>> +	const char *name;
>> +
>> +	int num_supplies;
>> +	struct regulator_consumer_supply *supplies;
> 
> Why are you using a regulator_consumer_supply here?  All that's being
> used here is the name and I can't see why you'd want the device.

For upwards compatibility :)
Well, seriously, I think using 'struct regulator_consumer_supply *supplies'
rather than 'char *supplies' makes the platform code that registers the
userspace-consumer device clearer.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.

