Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbYHRUS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbYHRUS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYHRUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:18:47 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43115 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbYHRUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:18:46 -0400
Date: Mon, 18 Aug 2008 22:18:44 +0200
From: Andreas Mohr <andi@lisas.de>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Andrew Morton <akpm@linux-foundation.org>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org
Subject: Re: [PATCH 2/2] acpi_pm.c: check for monotonicity
Message-ID: <20080818201844.GA3506@rhlx01.hs-esslingen.de>
References: <20080818200017.GA11247@rhlx01.hs-esslingen.de> <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de> <20080818190325.GA12581@comet.dominikbrodowski.net> <20080818121924.6b61f7af.akpm@linux-foundation.org> <20080818193517.GA22097@isilmar.linta.de> <20080818124755.162f24d1.akpm@linux-foundation.org> <20080818200916.GA18209@comet.dominikbrodowski.net> <20080818201115.GC18209@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818201115.GC18209@comet.dominikbrodowski.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 18, 2008 at 10:11:15PM +0200, Dominik Brodowski wrote:
> +	if (good != 10) {
> +		printk(KERN_INFO "PM-Timer had no reasonable result:"
> +		       " 0x%#llx - aborting.\n", value1);
> +		return -ENODEV;
>  	}
> -	printk(KERN_INFO "PM-Timer had no reasonable result:"
> -			" 0x%#llx - aborting.\n", value1);
> -	return -ENODEV;

Technically spoken this log message could now be considered partially
outdated... (we're doing 10 evaluations after all, not one with a
precise end result).


Seeing a define for those several open-coded 10 loops values would be nice.

Andreas Mohr
