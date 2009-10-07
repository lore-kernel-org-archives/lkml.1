Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbZJGTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbZJGTdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759889AbZJGTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZJGTdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:33:43 -0400
Message-ID: <4ACCECD4.1050509@redhat.com>
Date: Wed, 07 Oct 2009 15:32:36 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] mm: order evictable rescue in LRU putback
References: <1254940610-27324-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1254940610-27324-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:

> This patch adds an explicit full barrier to force ordering between
> SetPageLRU() and PageMlocked() so that either one of the competitors
> rescues the page.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
