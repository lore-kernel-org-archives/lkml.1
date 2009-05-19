Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZESC5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZESC5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 22:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZESC5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 22:57:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35540 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZESC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 22:57:42 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
In-Reply-To: <20090519102634.4EB4.A69D9226@jp.fujitsu.com>
References: <20090518034907.GF5869@localhost> <20090519102634.4EB4.A69D9226@jp.fujitsu.com>
Message-Id: <20090519115645.4EB7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 May 2009 11:57:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nit fix.

> In general, the feature of workload depended don't fit default option.
> we can't know end-user run what workload anyway.
> 
> Fortunately (or Unfortunately), typical workload and machine size had

typical workload and machine size and remote node distance

> significant mutuality.
> Thus, the current default setting calculation had worked well in past days.
> 
> Now, it was breaked. What should we do?
> 
> 
> 
> Yanmin, We know 99% linux people use intel cpu and you are one of
> most hard repeated testing guy in lkml and you have much test.
> May I ask your tested machine and benchmark? 
> 
> if zone_reclaim=0 tendency workload is much than zone_reclaim=1 tendency workload,
>  we can drop our afraid and we would prioritize your opinion, of cource.
> 
> thanks.
> 
> 



