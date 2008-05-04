Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYEDOjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYEDOjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYEDOjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:39:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55573 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbYEDOjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:39:05 -0400
Date: Sun, 04 May 2008 23:38:43 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [-mm][PATCH 0/5] mm: page reclaim throttle v6
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080504232854.8F69.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI:

page reclaim throttle + split lru series performance is below.
I think its combination is best.


    num_group       vanilla      with throttle     throttle + split lru
   -----------------------------------------------------------------
      80              26.22           24.97           23.75
      85              27.31           25.94           27.01
      90              29.23           26.77           26.90
      95              30.73           28.40           28.81
     100              32.02           30.62           29.18
     105              33.97           31.93           32.21
     110              35.37           33.19           33.10
     115              36.96           33.68           33.90
     120              74.05           36.25           36.58
     125              41.07           39.30           36.64
     130              86.92           45.74           40.55
     135             234.62           45.99           47.18
     140             291.95           57.82           58.91
     145             425.35           70.31           50.63
     150             766.92          113.28          105.33



