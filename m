Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZDZKCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZDZKCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 06:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZDZKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 06:02:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43206 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461AbZDZKCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 06:02:12 -0400
Date: Sun, 26 Apr 2009 11:02:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: add userspace-consumer driver
Message-ID: <20090426100211.GC9009@opensource.wolfsonmicro.com>
References: <cover.1240736991.git.mike@compulab.co.il> <f9c42ab0212ead9b7edac2d39f7848c46ad527d5.1240736991.git.mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9c42ab0212ead9b7edac2d39f7848c46ad527d5.1240736991.git.mike@compulab.co.il>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 12:17:23PM +0300, Mike Rapoport wrote:

> +/*
> + * line-consumer.c

Bitrot.

> +	for (i = 0; i < drvdata->num_supplies; i++)
> +		drvdata->supplies[i].supply = pdata->supplies[i].supply;

...

> +struct regulator_userspace_consumer_data {
> +	const char *name;
> +
> +	int num_supplies;
> +	struct regulator_consumer_supply *supplies;

Why are you using a regulator_consumer_supply here?  All that's being
used here is the name and I can't see why you'd want the device.
