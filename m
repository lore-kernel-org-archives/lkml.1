Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbZBFDVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbZBFDVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBFDV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:21:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57078 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZBFDV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:21:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/3] swsusp: dont fiddle with swappiness
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090206031323.916297777@cmpxchg.org>
References: <20090206031125.693559239@cmpxchg.org> <20090206031323.916297777@cmpxchg.org>
Message-Id: <20090206122019.79C9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  6 Feb 2009 12:21:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sc.swappiness is not used in the swsusp memory shrinking path, do not
> set it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

I agree. currently shrink_all_memory() use shrink_list() directly.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



