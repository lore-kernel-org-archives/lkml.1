Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZJBACT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZJBACT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZJBACS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:02:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49169 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbZJBACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:02:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch v2] oom: dump stack and VM state when oom killer panics
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0910011432001.6631@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0910011432001.6631@chino.kir.corp.google.com>
Message-Id: <20091002090118.5F54.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Oct 2009 09:02:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


thanks.



