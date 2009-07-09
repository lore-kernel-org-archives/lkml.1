Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbZGIXjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbZGIXjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZGIXjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:39:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56831 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZGIXjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:39:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/5] add buffer cache information to show_free_areas()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.DEB.1.10.0907091635070.17835@gentwo.org>
References: <20090709171027.23C0.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907091635070.17835@gentwo.org>
Message-Id: <20090710083741.17C1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Jul 2009 08:39:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 9 Jul 2009, KOSAKI Motohiro wrote:
> 
> > Subject: [PATCH] add buffer cache information to show_free_areas()
> >
> > When administrator analysis memory shortage reason from OOM log, They
> > often need to know rest number of cache like pages.
> 
> Maybe:
> 
> "
> It is often useful to know the statistics for all pages that are handled
> like page cache pages when looking at OOM log output.
> 
> Therefore show_free_areas() should also display buffer cache statistics.
> "

Thanks good description. Will fix.



