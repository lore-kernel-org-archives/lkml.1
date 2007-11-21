Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXKUChc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXKUChc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXKUChY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:37:24 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53846 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXKUChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:37:23 -0500
Date: Wed, 21 Nov 2007 11:37:21 +0900
From: =?ISO-2022-JP?B?GyRCPi46ajtxOS0bKEI=?= 
	<kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 4/6] Use two zonelist that are filtered by GFP mask
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
       linux-mm@kvack.org
In-Reply-To: <20071121004008.10789.97361.sendpatchset@skynet.skynet.ie>
References: <20071121003848.10789.18030.sendpatchset@skynet.skynet.ie> <20071121004008.10789.97361.sendpatchset@skynet.skynet.ie>
Message-Id: <20071121113403.689F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> +static inline enum zone_type gfp_zonelist(gfp_t flags)
> +{
> +	if (NUMA_BUILD && unlikely(flags & __GFP_THISNODE))
> +		return 1;
> +
> +	return 0;
> +}
> +

static inline int gfp_zonelist(gfp_t flags) ?

if not, why no use ZONE_XXX macro.


----
kosaki


