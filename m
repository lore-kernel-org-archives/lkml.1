Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZBFDUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZBFDUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBFDUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:20:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52019 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZBFDUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:20:21 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] swsusp: clean up shrink_all_zones()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090206031323.821014885@cmpxchg.org>
References: <20090206031125.693559239@cmpxchg.org> <20090206031323.821014885@cmpxchg.org>
Message-Id: <20090206121853.79C6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  6 Feb 2009 12:20:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Move local variables to innermost possible scopes and use local
> variables to cache calculations/reads done more than once.
> 
> No change in functionality (intended).
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)

ok. good cleanup.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




