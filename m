Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZIRA0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZIRA0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZIRA0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:26:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46290 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZIRA0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:26:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch] oom: dump stack and VM state when oom killer panics
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0909171354570.17483@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909171354570.17483@chino.kir.corp.google.com>
Message-Id: <20090918092427.8E48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 18 Sep 2009 09:26:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

> The oom killer header, including information such as the allocation order
> and gfp mask, current's cpuset and memory controller, call trace, and VM
> state information is currently only shown when the oom killer has
> selected a task to kill.
> 
> This information is omitted, however, when the oom killer panics either
> because of panic_on_oom sysctl settings or when no killable task was
> found.  It is still relevant to know crucial pieces of information such
> as the allocation order and VM state when diagnosing such issues,
> especially at boot.
> 
> This patch displays the oom killer header whenever it panics so that bug
> reports can include pertinent information to debug the issue, if
> possible.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Good patch :)

I have one request. In panic case, I don't hope to call printk_ratelimit().
the infomation should be displayed always.

Thanks.




