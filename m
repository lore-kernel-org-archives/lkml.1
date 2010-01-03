Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867Ab0ACXvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0ACXvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792Ab0ACXvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:51:51 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51220 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0ACXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:51:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 4 Jan 2010 08:48:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/4] vmstat: remove zone->lock from walk_zones_in_node
Message-Id: <20100104084838.fd229ec0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228164451.A687.A69D9226@jp.fujitsu.com>
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 16:47:22 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> The zone->lock is one of performance critical locks. Then, it shouldn't
> be hold for long time. Currently, we have four walk_zones_in_node()
> usage and almost use-case don't need to hold zone->lock.
> 
> Thus, this patch move locking responsibility from walk_zones_in_node
> to its sub function. Also this patch kill unnecessary zone->lock taking.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

