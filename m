Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZDZNGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZDZNGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZDZNGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:06:45 -0400
Received: from cathcart.site5.com ([74.54.107.137]:58319 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDZNGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:06:44 -0400
Message-ID: <49F45C34.9010207@compulab.co.il>
Date: Sun, 26 Apr 2009 16:05:56 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: add userspace-consumer driver
References: <cover.1240736991.git.mike@compulab.co.il> <f9c42ab0212ead9b7edac2d39f7848c46ad527d5.1240736991.git.mike@compulab.co.il> <20090426100211.GC9009@opensource.wolfsonmicro.com> <49F449B8.2010707@compulab.co.il> <20090426120036.GA10900@opensource.wolfsonmicro.com>
In-Reply-To: <20090426120036.GA10900@opensource.wolfsonmicro.com>
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
> On Sun, Apr 26, 2009 at 02:47:04PM +0300, Mike Rapoport wrote:
>> Mark Brown wrote:
> 
>>> Why are you using a regulator_consumer_supply here?  All that's being
>>> used here is the name and I can't see why you'd want the device.
> 
>> For upwards compatibility :)
>> Well, seriously, I think using 'struct regulator_consumer_supply *supplies'
>> rather than 'char *supplies' makes the platform code that registers the
>> userspace-consumer device clearer.
> 
> On the other hand it merges the consumer and machine APIs, which we
> really want to keep separate, and I can't see having the struct device
> in there doing anything except confuse people.  If you're going to pick
> an existing structure to use I'd be more inclined to use the bulk
> consumer structure (which the driver needs to allocate anyway).

Ok, I'll use bulk consumer and then apparently I can avoid it's allocation...


-- 
Sincerely yours,
Mike.

