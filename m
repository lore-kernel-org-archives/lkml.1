Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZHCMUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZHCMUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZHCMUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:20:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33585 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZHCMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:19:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090803175557.645b9ca3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090803174519.74673413.kamezawa.hiroyu@jp.fujitsu.com> <20090803175557.645b9ca3.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090803211812.CC29.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  3 Aug 2009 21:19:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 3 Aug 2009 17:45:19 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > "just inherit at fork, change at exec" is an usual manner, I think.
> > If oom_adj_exec rather than oom_adj_child, I won't complain, more.
> > 
> But this/(and yours) requires users to rewrite their apps.
> Then, breaks current API.
> please fight with other guardians.

Definitely, I never agree regressionful ABI change ;)
At least, I still think it can be fixable.




