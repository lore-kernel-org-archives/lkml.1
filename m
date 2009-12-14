Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZLNOp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZLNOp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZLNOp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:45:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZLNOpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:45:55 -0500
Message-ID: <4B264F77.6040603@redhat.com>
Date: Mon, 14 Dec 2009 09:45:11 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 6/8] Stop reclaim quickly when the task reclaimed enough
 lots pages
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com> <20091214213103.BBC0.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091214213103.BBC0.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 07:31 AM, KOSAKI Motohiro wrote:
>
>  From latency view, There isn't any reason shrink_zones() continue to
> reclaim another zone's page if the task reclaimed enough lots pages.

IIRC there is one reason - keeping equal pageout pressure
between zones.

However, it may be enough if just kswapd keeps evening out
the pressure, now that we limit the number of concurrent
direct reclaimers in the system.

Since kswapd does not use shrink_zones ...

> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
