Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYDRIiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYDRIiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYDRIij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:38:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57190 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYDRIii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:38:38 -0400
Date: Fri, 18 Apr 2008 10:38:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080418083824.GA9636@elte.hu>
References: <20080416202338.GA6007@elte.hu> <878wzdikwk.fsf@basil.nowhere.org> <1208426793.10305.1248377703@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208426793.10305.1248377703@webmail.messagingengine.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> My conclusion would be: the speed of the generic bitmap implementation 
> is either better than or at least comparable to the current private 
> implementations in i386/x86_64. The generic version is out-of-line, 
> while the private implementation of i386 was inlined: this causes a 
> regression for very small bitmaps. However, if the bitmap size is a 
> constant and fits a long integer, the updated generic code should 
> inline an optimized version, like x86_64 currently does it.
> 
> I think the change is a good one.

quite so. Your change was promising from the get go and the latest 
iteration was definitely a good one and is very much mergable. That it 
also helps improve other architectures is the icing on the cake.

Andi will have to prove his points by coming up with competing benchmark 
results - you certainly did your fair share to back up your change with 
numbers. (and Andi, if/when you do so, please Cc: Alexander too in the 
future. Dont you want him to be able to reply to your complaints ASAP?)

I dont really understand the negativism that comes from Andi - he was 
very much aware of the various iterations and benchmarks you did when 
developing this rather cool feature: he participated in those threads 
and was Cc:-ed as well. The "100% bogus benchmark with the most 
unrealistic input data set one can imagine" remark from Andi with no Cc: 
was a nasty and unprovoked hit below the waistline.

	Ingo
