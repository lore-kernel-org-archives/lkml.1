Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJBHAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJBHAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYJBHAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:00:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56378 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYJBHAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:00:04 -0400
Date: Thu, 2 Oct 2008 16:05:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] pull out the page pre-release and sanity check
 logic for reuse
Message-Id: <20081002160512.b87c3440.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1222864261-22570-2-git-send-email-apw@shadowen.org>
References: <1222864261-22570-1-git-send-email-apw@shadowen.org>
	<1222864261-22570-2-git-send-email-apw@shadowen.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2008 13:30:58 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

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
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiruyo@jp.fujitsu.com>

