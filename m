Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbYLHS2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbYLHS2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYLHS2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:28:22 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:41518 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYLHS2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:28:21 -0500
Date: Mon, 8 Dec 2008 20:28:12 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, dmitry.torokhov@gmail.com,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       linux-input@vger.kernel.org, lauri.leukkunen@nokia.com
Subject: Re: [PATCH] Add TI TSC2005 Touchscreen driver
Message-ID: <20081208182812.GD13076@frodo>
Reply-To: me@felipebalbi.com
References: <5d5443650812080949h5aff6010mb7341f581841f126@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650812080949h5aff6010mb7341f581841f126@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 11:19:53PM +0530, Trilok Soni wrote:
> +static ssize_t tsc2005_disable_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct tsc2005		*tsc = dev_get_drvdata(dev);
> +	unsigned long res;
> +	int i;
> +
> +	i = strict_strtoul(buf, 10, &res);
> +	i = i ? 1 : 0;

shouldn't this be i = res ? 1 : 0; ??

-- 
balbi
