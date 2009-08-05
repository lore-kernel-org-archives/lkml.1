Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbZHEGrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbZHEGrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933070AbZHEGrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:47:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56750 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030AbZHEGre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:47:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/4] oom: move oom_adj to signal_struct
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090805152956.faf52a5a.minchan.kim@barrios-desktop>
References: <20090805150017.5BB9.A69D9226@jp.fujitsu.com> <20090805152956.faf52a5a.minchan.kim@barrios-desktop>
Message-Id: <20090805153157.5BBF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Aug 2009 15:47:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > What do you think about this approach ?
> > 
> > I can ack this. but please re-initialize oom_scale_down at fork and
> > exec time.
> > currently oom_scale_down makes too big affect.
> 
> 
> Thanks for carefult review. 
> In fact, I didn't care of it 
> since it just is RFC for making sure my idea. :)

ok, I see.

> > and, May I ask which you hate my approach? 
> 
> Not at all. I never hate your approach. 
> This problem resulted form David's original patch.
> I thought if we will fix live lock with different approach, we can remove much pain.

I also think your approach is enough acceptable.

ok, Let's wait one night and to hear other developer's opinion.
We can choice more lkml preferred approach :)



