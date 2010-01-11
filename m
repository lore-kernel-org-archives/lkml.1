Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961Ab0AKDrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab0AKDrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 22:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578Ab0AKDrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 22:47:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0AKDrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 22:47:05 -0500
Message-ID: <4B4A9F12.8020200@redhat.com>
Date: Sun, 10 Jan 2010 22:46:26 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 -mmotm-2010-01-06-14-34] check high watermark after
 shrink zone
References: <20100111084816.81bc7ebd.minchan.kim@barrios-desktop>
In-Reply-To: <20100111084816.81bc7ebd.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2010 06:48 PM, Minchan Kim wrote:
>
>
>   * V2
>    * Add reviewed-by singed-off (Thanks Kosaki, Wu)
>    * Fix typo of changelog
>
> == CUT HERE ==
>
> Kswapd check that zone have enough free by zone_water_mark.
> If any zone doesn't have enough page, it set all_zones_ok to zero.
> !all_zone_ok makes kswapd retry not sleeping.
>
> I think the watermark check before shrink zone is pointless.
> Kswapd try to shrink zone then the check is meaninful.
>
> This patch move the check after shrink zone.
>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
> Reviewed-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Wu Fengguang<fengguang.wu@intel.com>
> CC: Mel Gorman<mel@csn.ul.ie>
> CC: Rik van Riel<riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
