Return-Path: <linux-kernel-owner+w=401wt.eu-S1031304AbXDJRte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031304AbXDJRte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031318AbXDJRte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:49:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031304AbXDJRtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:49:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>, acahalan@gmail.com
Subject: Re: [PATCH] Only send pdeath_signal when getppid changes.
In-Reply-To: Eric W. Biederman's message of  Tuesday, 10 April 2007 11:41:20 -0600 <m1ejmsxh33.fsf@ebiederm.dsl.xmission.com>
X-Zippy-Says: Let's all show human CONCERN for REVEREND MOON's legal difficulties!!
Message-Id: <20070410174852.88661D82F8@pipsqueak.sf.frob.com>
Date: Tue, 10 Apr 2007 10:48:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does a parent death signal make most sense between separately written programs?

I don't think it does.  It has always seemed an utterly cockamamy feature
to me, and I've never understood what actually motivated it.

> Does a parent death signal make most sense between processes that are part of
> a larger program.

That is the only way I can really see it being used.  The only actual
example of use I know is what Albert Cahalan reported.  To my mind, the
only semantics that matter for pdeath_signal are what previous uses
expected in the past and still need for compatibility.  If we started with
a fresh rationale from the ground up on what the feature is good for, I am
rather skeptical it would pass muster to be added today.


Thanks,
Roland
