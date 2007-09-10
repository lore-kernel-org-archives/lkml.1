Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbXIJIZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbXIJIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 04:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbXIJIZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 04:25:20 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50523 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbXIJIZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 04:25:19 -0400
Message-ID: <46E4FF52.2060407@linux.vnet.ibm.com>
Date: Mon, 10 Sep 2007 13:54:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make do_try_to_free_pages() static
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202601.GA3563@stusta.de>
In-Reply-To: <20070909202601.GA3563@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>> ...
>> Changes since 2.6.23-rc3-mm1:
>> ...
>> +memory-controller-add-per-container-lru-and-reclaim-v7.patch
>> ...
>>  memory containment
>> ...
> 
> do_try_to_free_pages() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 23781fa6792c518c8581ceeaf08db251574e8430 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b34b29d..9104cf8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1248,8 +1248,8 @@ static unsigned long shrink_zones(int priority, struct zone **zones,
>   * holds filesystem locks which prevent writeout this might not work, and the
>   * allocation attempt will fail.
>   */
> -unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
> -					struct scan_control *sc)
> +static unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
> +					  struct scan_control *sc)
>  {
>  	int priority;
>  	int ret = 0;
> 

Thanks, looks good!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
