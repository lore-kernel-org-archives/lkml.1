Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZFHOd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZFHOd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZFHOdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:33:51 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55441 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755210AbZFHOdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:33:50 -0400
Date: Mon, 8 Jun 2009 10:33:41 -0400 (EDT)
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
In-Reply-To: <20090608135433.GD15070@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906081033060.21954@gentwo.org>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-2-git-send-email-mel@csn.ul.ie> <4A2D129D.3020309@redhat.com> <20090608135433.GD15070@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Mel Gorman wrote:

> Yes, they're on separate LRU lists but they are not the only pages on those
> lists. The tmpfs pages are mixed in together with anonymous pages so we
> cannot use NR_*_ANON.

The tmpfs pages are unreclaimable and therefore should not be on the anon
lru.
