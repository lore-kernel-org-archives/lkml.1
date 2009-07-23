Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZGWXVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZGWXVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZGWXVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:21:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55338 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZGWXVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:21:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
In-Reply-To: <6599ad830907211303m25141938kcb75065a74a40ee2@mail.gmail.com>
References: <alpine.DEB.2.00.0907211258500.10356@chino.kir.corp.google.com> <6599ad830907211303m25141938kcb75065a74a40ee2@mail.gmail.com>
Message-Id: <20090722233347.776E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 24 Jul 2009 08:21:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 21, 2009 at 1:00 PM, David Rientjes<rientjes@google.com> wrote:
> > On Tue, 21 Jul 2009, Paul Menage wrote:
> >
> >> Agreed, but the same livelock can be fixed in ways that don't break
> >> the API. (E.g. check for the victim being OOM_DISABLED in
> >> select_bad_process() when we find a new "worst" candidate).
> >>
> >
> > And allow /proc/pid-of-child/oom_score to represent a possible candidate
> > (and, additionally, a hint at the oom killing priority) when it really
> > isn't?

Oops, I really don't like  /proc/pid-of-child/oom_score. it is very strange.

> 
> It's the API that's existed for years with no complaints, AFAICS.

I think thead and vfork() should be separeted on this discussion.
I agree vfork() regression should be fixed. but I don't think anyone
hope per-thread oom score. 

Of cource, if simple reverting is best way, I don't oppose this.... ;-)



