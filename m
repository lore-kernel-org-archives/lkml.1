Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYADOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYADOjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYADOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:39:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:41223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbYADOja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:39:30 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less frequently
Date: Fri, 4 Jan 2008 15:39:27 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <20080103442.621670000@suse.de> <200801041317.30404.ak@suse.de> <alpine.LFD.0.99999.0801041449460.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.99999.0801041449460.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041539.27370.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The kernel process request that _all_ contributors run their patches 
> through checkpath.pl and fix the problems.

That's new. When and by whom was that rule been introduced? And with what
rationale?

Even checkpatch.pl itself says to only fix the warnings that make sense.
This one didn't. And it has so many false positives in my experiences
that a lot of its warnings are useless.

So even if you require checkpatch.pl compliance it will be always
subjective because checkpatch.pl is not always correct.

Anyways if you care so much about space<->tabs why don't you just write
a filter that converts spaces to tabs for incoming patches? Like it is
traditionally done for trailing white spaces? Would be a trivial perl script.

Bothering humans with such a silly mindless thing is beyond ridiculous.

> The review process is the 
> same for _all_ contributors and I'm not going to add an extra Andi
> attitude mode to it.
 
I wish you guys would care more about actually broken logic in patches than just 
checkpatch.pl output. When I occasionally check git-x86 I always tend to find some 
obviously broken patch that should have been caught during review before
merge.

-Andi
