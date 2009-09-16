Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZIPPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZIPPGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZIPPGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:06:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35097 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759191AbZIPPGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:06:20 -0400
Date: Wed, 16 Sep 2009 17:05:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, jmorris@namei.org, eparis@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Have the garbage collector set its timer for
	live expired keys
Message-ID: <20090916150556.GA23523@elte.hu>
References: <20090916145414.31860.16602.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916145414.31860.16602.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> The key garbage collector sets a timer to start a new collection cycle at the
> point the earliest key to expire should be considered garbage.  However, it
> currently only does this if the key it is considering hasn't yet expired.
> 
> If the key being considering has expired, but hasn't yet reached the collection
> time then it is ignored, and won't be collected until some other key provokes a
> round of collection.
> 
> Make the garbage collector set the timer for the earliest key that hasn't yet
> passed its collection time, rather than the earliest key that hasn't yet
> expired.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Is this in response to my bugreport? (If yes then the changelog is quite 
vague about the circumstances of the bug, its effects, which tools were 
used to find it, etc. etc.)

	Ingo
