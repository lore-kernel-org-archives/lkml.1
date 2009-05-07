Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZEGIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZEGIVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZEGIVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:21:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZEGIVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:21:22 -0400
Date: Thu, 7 May 2009 10:20:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507082027.GD12285@elte.hu>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507063606.GA15220@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> /* the callers of ptrace_may_access should be fixed */
> 
> 	int ptrace_may_access(struct task_struct *task, unsigned int mode)

Sigh, NAK, for the reasons explained in the previous mails.

	Ingo
