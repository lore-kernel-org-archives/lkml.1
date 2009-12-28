Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbZL1DSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbZL1DSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 22:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZL1DSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 22:18:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35335 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZL1DSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 22:18:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page in LRU list.
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
References: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
Message-Id: <20091228121758.A67E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Dec 2009 12:18:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> VM doesn't add zero page to LRU list. 
> It means zero page's churning in LRU list is pointless. 
> 
> As a matter of fact, zero page can't be promoted by mark_page_accessed
> since it doesn't have PG_lru. 
> 
> This patch prevent unecessary mark_page_accessed call of zero page 
> alghouth caller want FOLL_TOUCH. 
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



