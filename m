Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYCBOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYCBOYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 09:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYCBOYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 09:24:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbYCBOYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 09:24:39 -0500
Date: Sun, 2 Mar 2008 09:23:50 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [patch 11/21] (NEW) more aggressively use lumpy reclaim
Message-ID: <20080302092350.684ca7f6@bree.surriel.com>
In-Reply-To: <20080302193024.1E72.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080228192908.126720629@redhat.com>
	<20080228192928.954667833@redhat.com>
	<20080302193024.1E72.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Mar 2008 19:35:44 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> I think this patch is very good improvement.
> but it is not related to split lru.
> 
> Why don't you separate this patch?
> IMHO treat as independent patch is better.

Agreed, I should probably pull this to the start of the patch series
and submit it to Andrew Morton soon.

The arrayification of the LRU lists and pagevecs should probably go
into -mm soon, as well.  That code is ready and it can be merged
independently of the split VM code.

-- 
All rights reversed.
