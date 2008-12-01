Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbYLANmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbYLANmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 08:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYLANlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 08:41:53 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:35370 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYLANlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:41:52 -0500
Date: Mon, 1 Dec 2008 07:40:41 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH] vmscan: bail out of page reclaim after swap_cluster_max
 pages
In-Reply-To: <49316CAF.2010006@redhat.com>
Message-ID: <Pine.LNX.4.64.0812010736240.11954@quilx.com>
References: <20081128140405.3D0B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <492FCFF6.1050808@redhat.com> <20081129164624.8134.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <49316CAF.2010006@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008, Rik van Riel wrote:

> When using mmap or memory hogs writing to swap, applications
> will not be throttled by the "too many dirty pages" logic,
> but may instead end up being throttled in the direct reclaim
> path instead.

The too many dirty pages logic will throttle applications dirtying
mmapped pages these days.



