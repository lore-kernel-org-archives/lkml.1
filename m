Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbYKGSpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbYKGSpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYKGSpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:45:36 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:47953 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYKGSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:45:36 -0500
Date: Fri, 7 Nov 2008 12:45:20 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Mel Gorman <mel@csn.ul.ie>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into
 pcp
In-Reply-To: <20081107112722.GE13786@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0811071244330.5387@quilx.com>
References: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20081106164644.GA14012@csn.ul.ie> <20081107104224.1631057e.kamezawa.hiroyu@jp.fujitsu.com>
 <20081107104242.GC13786@csn.ul.ie> <20081107200251.15e9851a.kamezawa.hiroyu@jp.fujitsu.com>
 <20081107112722.GE13786@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Mel Gorman wrote:

> Oh, do you mean splitting the list instead of searching? This is how it was
> originally implement and shot down on the grounds it increased the size of
> a per-cpu structure.

The situation may be better with the cpu_alloc stuff. The big pcp array in
struct zone for all possible processors will be gone and thus the memory
requirements will be less.
