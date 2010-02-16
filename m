Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0BPGBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:01:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51284 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0BPGBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:01:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 1/7 -mm] oom: filter tasks not sharing the same cpuset
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100216110859.72C6.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.2.00.1002151401280.26927@chino.kir.corp.google.com> <20100216110859.72C6.A69D9226@jp.fujitsu.com>
Message-Id: <20100216150100.72F7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 15:01:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


typo.

> But this explanation is irrelevant and meaningless. CPUSET can change

s/CPUSET/mempolicy/

> restricted node dynamically. So, the tsk->mempolicy at oom time doesn't
> represent the place of task's usage memory. plus, OOM_DISABLE can 
> always makes undesirable result. it's not special in this case.
> 
> The fact is, both current and your heuristics have a corner case. it's
> obvious. (I haven't seen corner caseless heuristics). then talking your
> patch's merit doesn't help to merge the patch. The most important thing
> is, we keep no regression. personally, I incline your one. but It doesn't
> mean we can ignore its demerit.
> 
> 
> 



