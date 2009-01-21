Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZAUKSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZAUKSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764212AbZAUKOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:14:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764331AbZAUKOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:14:16 -0500
Date: Wed, 21 Jan 2009 11:14:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] x86: Merge hardirq.h
Message-ID: <20090121101400.GE18728@elte.hu>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232457345-12366-5-git-send-email-brgerst@gmail.com> <4976DA9C.7000500@kernel.org> <4976E1CF.9050801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4976E1CF.9050801@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> Tejun Heo wrote:
> > Brian Gerst wrote:
> >> Remove unused idle_timestamp field from 32-bit.
> > 
> > Dropped.  X86_32 doesn't build.  X86_64 UP doesn't build.  Please at
> > least do compile testing on all four combinations before sending the
> > patches.
> 
> One more thing, can you please split the patch into two such that the 
> merging and renaming happen as separate steps so that git can tell that 
> a file has been renamed instead of oh two of those disappeared and this 
> one popped up?  It's a bit tedious but makes log tracking much easier.

yes, we do that for all unification patches - the 'large patch' must 
always be a simple "git mv", with nothing modified inbetween. That way 
it's reviewable and debuggable as well.

	Ingo
