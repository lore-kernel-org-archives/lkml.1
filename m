Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399Ab0ADDN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0ADDN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322Ab0ADDNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:13:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50579 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0ADDNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:13:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v2 -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matt Mackall <mpm@selenic.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100104102319.b878047d.minchan.kim@barrios-desktop>
References: <20100104102319.b878047d.minchan.kim@barrios-desktop>
Message-Id: <20100104121312.969D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  4 Jan 2010 12:13:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Long time ago, We regards zero page as file_rss and
> vm_normal_page didn't return NULL in case of zero page
> 
> But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
> can return NULL in case of zero page.
> 
> Then, RSS and PSS can't be matched in smaps_pte_range.
> This patch fixes it.
> 
> Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Acked-by: Matt Mackall <mpm@selenic.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



