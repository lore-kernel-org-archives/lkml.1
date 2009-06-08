Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZFHO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZFHO4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZFHO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:56:09 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46700 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753905AbZFHO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:56:08 -0400
Date: Mon, 8 Jun 2009 10:55:55 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       yanmin.zhang@intel.com, Wu Fengguang <fengguang.wu@intel.com>,
       linuxram@us.ibm.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when zone_reclaim()
 scans and fails to avoid CPU spinning at 100% on NUMA
In-Reply-To: <20090608143857.GG15070@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906081055170.21954@gentwo.org>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-2-git-send-email-mel@csn.ul.ie> <4A2D129D.3020309@redhat.com> <20090608135433.GD15070@csn.ul.ie> <alpine.DEB.1.10.0906081033060.21954@gentwo.org>
 <20090608143857.GG15070@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Mel Gorman wrote:

> > The tmpfs pages are unreclaimable and therefore should not be on the anon
> > lru.
> >
>
> tmpfs pages can be swap-backed so can be reclaimable. Regardless of what
> list they are on, we still need to know how many of them there are if
> this patch is to be avoided.

If they are reclaimable then why does it matter? They can be pushed out if
you configure zone reclaim to be that aggressive.


