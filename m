Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYKKIOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYKKIOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYKKIN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:13:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53752 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYKKIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:13:57 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0811071244330.5387@quilx.com>
References: <20081107112722.GE13786@csn.ul.ie> <Pine.LNX.4.64.0811071244330.5387@quilx.com>
Message-Id: <20081111171312.8B32.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 11 Nov 2008 17:13:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Oh, do you mean splitting the list instead of searching? This is how it was
> > originally implement and shot down on the grounds it increased the size of
> > a per-cpu structure.
> 
> The situation may be better with the cpu_alloc stuff. The big pcp array in
> struct zone for all possible processors will be gone and thus the memory
> requirements will be less.

Yup, there are very nicer patch!



