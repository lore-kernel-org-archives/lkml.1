Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZBVQXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZBVQXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 11:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZBVQXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 11:23:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39112 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZBVQXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 11:23:31 -0500
Date: Sun, 22 Feb 2009 17:23:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, zippel@linux-m68k.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RFC] check for select dependency errors on config load
Message-ID: <20090222162311.GA25417@elte.hu>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <alpine.DEB.2.00.0902210008580.30069@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902210008580.30069@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> There's been a few problems with SELECT and dependencies 
> lately. I've been burnt by it a few times myself. So I look at 
> the kconfig code and added this patch. It can use a bit more 
> work but it does what I want.
> 
> When the config is loaded, it checks all the symbols that are 
> selected by an active config and makes sure the visible 
> dependencies are also activated. This should probably be moved 
> to the writing of the config instead, but since I just wanted 
> to see if my current config was OK, I did it on load. This is 
> an RFC patch anyway, so fixes/comments are definitely welcome.
> 
> Here's what I get with the attached config running on 
> 2.6.29-rc5.

Yah! Very nice Steve.

/me nominates Steve as the Kconfig maintainer :-)

	Ingo
