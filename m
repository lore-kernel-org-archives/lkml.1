Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbZEAUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbZEAUhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764885AbZEAUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:37:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763862AbZEAUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:37:03 -0400
Date: Fri, 1 May 2009 22:36:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements,
	faster than Bkl based scheme
Message-ID: <20090501203639.GA9396@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.00.0905011236530.5379@localhost.localdomain> <20090501203309.GA6243@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501203309.GA6243@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> The BKL is clearly removed at a faster reate with such debugging 
> measures in place. With such measures the BKL _really_ hurts, and 
> very visibly so - and that results in active removal.

Btw., if you can think of any way to create a cleaner debug tool 
here i'd be glad to start a new tree that adds only _that_ tool - 
and that could perhaps be dealt with independently and possibly 
pulled upstream too, if clean enough.

The problem is, i think it would still quack like a global mutex, 
would walk like a global mutex and would look like a global mutex
:-/

	Ingo
