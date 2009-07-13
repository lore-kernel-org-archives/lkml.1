Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZGMBuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZGMBuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 21:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZGMBuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 21:50:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58871 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZGMBuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 21:50:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.DEB.1.10.0907101447370.14152@gentwo.org>
References: <20090710094934.17CA.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907101447370.14152@gentwo.org>
Message-Id: <20090713104954.624C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 13 Jul 2009 10:50:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 10 Jul 2009, KOSAKI Motohiro wrote:
> 
> > Plus, current reclaim logic depend on the system have enough much pages on LRU.
> > Maybe we don't only need to limit #-of-reclaimer, but also need to limit #-of-migrator.
> > I think we can use similar logic.
> 
> I think your isolate pages counters can be used in both locations.
> 

I totally agree this :)




