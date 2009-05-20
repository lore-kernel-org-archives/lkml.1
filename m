Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZETH0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZETH0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZETH0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:26:32 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:41213 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZETH0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=wTv3MvTXunt2diIXDuARJIF913WZnk5n8U+18YX7oaNWSEPm1OgCaQ6Md4ZU77WfyV
         CtPju59/UifBCOR40S4kxyTTCM5v3d77W215w5SaB7WuNrhFE6inPm4jvNcp76fBcuh3
         T5DWNGwQELpaUUqcIIFWNhgsqlwfkOYGSRzx4=
Date: Wed, 20 May 2009 16:26:23 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] clean up setup_per_zone_pages_min
Message-Id: <20090520162623.1e03a5e4.minchan.kim@barrios-desktop>
In-Reply-To: <20090520162231.7446.A69D9226@jp.fujitsu.com>
References: <20090520161853.1bfd415c.minchan.kim@barrios-desktop>
	<20090520162231.7446.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 16:23:46 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > Mel changed zone->pages_[high/low/min] with zone->watermark array.
> > So, setup_per_zone_pages_min also have to be changed.
> 
> Only naming change?
> if so, the description sould talk about this explicitly.
> 
>  - kosaki
> 

OK. I will add it in next version. 
Thanks, Kosaki. 

-- 
Kinds Regards
Minchan Kim
