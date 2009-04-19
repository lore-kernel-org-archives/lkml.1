Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZDSSsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZDSSsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 14:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZDSSrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 14:47:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZDSSrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 14:47:53 -0400
Date: Sun, 19 Apr 2009 20:47:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/core: Add current context on tracing recursion
	warning
Message-ID: <20090419184731.GB6120@elte.hu>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <49EAC15E.7080702@cn.fujitsu.com> <20090419123430.GA5967@nowhere> <20090419134927.GA6262@nowhere> <20090419140154.GB28919@elte.hu> <20090419142201.GB6262@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419142201.GB6262@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> [ Impact: more information in tracing recursion ]

Small sidenote for next time around: please always try to use a verb 
in impact lines. So this:

> [ Impact: print more information when tracing recurses ]

would have been a better one. (But the above one is unambigous as 
well at a second glance - so no need to redo the commit.)

	Ingo
