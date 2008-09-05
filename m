Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYIEBxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYIEBxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 21:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYIEBxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 21:53:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54410 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYIEBxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 21:53:01 -0400
Date: Fri, 05 Sep 2008 10:52:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/4] pull out the page pre-release and sanity check logic for reuse
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1220467452-15794-2-git-send-email-apw@shadowen.org>
References: <1220467452-15794-1-git-send-email-apw@shadowen.org> <1220467452-15794-2-git-send-email-apw@shadowen.org>
Message-Id: <20080905105124.5A44.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When we are about to release a page we perform a number of actions
> on that page.  We clear down any anonymous mappings, confirm that
> the page is safe to release, check for freeing locks, before mapping
> the page should that be required.  Pull this processing out into a
> helper function for reuse in a later patch.
> 
> Note that we do not convert the similar cleardown in free_hot_cold_page()
> as the optimiser is unable to squash the loops during the inline.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





