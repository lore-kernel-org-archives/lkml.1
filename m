Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412Ab0AHAVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0AHAVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098Ab0AHAVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:21:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47841 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0AHAVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:21:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: revert to show stack information in /proc/{pid}/status
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20100107135246.0849d609.akpm@linux-foundation.org>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com> <20100107135246.0849d609.akpm@linux-foundation.org>
Message-Id: <20100108091658.C127.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  8 Jan 2010 09:21:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 31 Dec 2009 23:12:22 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Thus, this patch revert it.
> 
> OK, thanks, I applied the full revert.
> 
> We can look at a new and less costly implementation of this feature for
> 2.6.34 if desired.  In which case, all we have done is to delay the feature
> by one release, which is not a big deal.

Thanks.

note: my patch isn't full revert too. Commit d899bf7b introduced two
feature (btw, I don't like one patch have two feature).

 1) Add the annotattion of [thread stack: xxxx] mark to
    /proc/{pid}/task/{tid}/maps.
 2) Add StackUsage field to /proc/{pid}/status.

I only revert (2), because I haven't seen (1) cause regression.



