Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZGRN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZGRN0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 09:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZGRN0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 09:26:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55447 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZGRN0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 09:26:34 -0400
Date: Sat, 18 Jul 2009 15:25:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: a.p.zijlstra@chello.nl, andi@firstfloor.org, fweisbec@gmail.com,
       acme@redhat.com, linux-kernel@vger.kernel.org, jbaron@redhat.com
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
	how many spinlocks to schedstat
Message-ID: <20090718132535.GC32618@elte.hu>
References: <1247405045.6733.2.camel@laptop> <20090713.150612.886429910823138064.mitake@dcl.info.waseda.ac.jp> <20090713085119.GA6757@elte.hu> <20090714.094804.869026176829743314.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714.094804.869026176829743314.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> Date: Mon, 13 Jul 2009 10:51:19 +0200
> 
> > X-Mew-Uidl: 4144 3205
> > Return-Path: <mingo@elte.hu>
> > Received: from murder ([unix socket])
> > 	 by ns.dcl.info.waseda.ac.jp (Cyrus v2.3.8-OS X Server 10.5:	9F33) with LMTPA;
> > 	 Mon, 13 Jul 2009 17:51:35 +0900
> > X-Sieve: CMU Sieve 2.3
> > Received: from localhost (localhost [127.0.0.1])
> > 	by ns.dcl.info.waseda.ac.jp (Postfix) with ESMTP id 418376729D2
> > 	for <mitake@dcl.info.waseda.ac.jp>; Mon, 13 Jul 2009 17:51:35 +0900 (JST)
> > X-Virus-Scanned: amavisd-new at dcl.info.waseda.ac.jp
> > Received: from ns.dcl.info.waseda.ac.jp ([127.0.0.1])
> > 	by localhost (ns.dcl.info.waseda.ac.jp [127.0.0.1]) (amavisd-new, port 10024)
> > 	with ESMTP id 4VNvZ6jG1jE9 for <mitake@dcl.info.waseda.ac.jp>;
> > 	Mon, 13 Jul 2009 17:51:34 +0900 (JST)
> > Received: from mx3.mail.elte.hu (mx3.mail.elte.hu [157.181.1.138])
> > 	by ns.dcl.info.waseda.ac.jp (Postfix) with ESMTP id C08246729C2
> > 	for <mitake@dcl.info.waseda.ac.jp>; Mon, 13 Jul 2009 17:51:33 +0900 (JST)
> > Received: from elvis.elte.hu ([157.181.1.14])
> > 	by mx3.mail.elte.hu with esmtp (Exim)
> > 	id 1MQHFr-0003wM-HT
> > 	from <mingo@elte.hu>; Mon, 13 Jul 2009 10:51:28 +0200
> > Received: by elvis.elte.hu (Postfix, from userid 1004)
> > 	id 115B83E22CE; Mon, 13 Jul 2009 10:51:21 +0200 (CEST)
> > Message-ID: <20090713085119.GA6757@elte.hu>
> > References: <1247230336.7529.34.camel@twins> <20090712.162337.287595819039280884.mitake@dcl.info.waseda.ac.jp> <1247405045.6733.2.camel@laptop> <20090713.150612.886429910823138064.mitake@dcl.info.waseda.ac.jp>
> > MIME-Version: 1.0
> > In-Reply-To: <20090713.150612.886429910823138064.mitake@dcl.info.waseda.ac.jp>
> > X-ELTE-SpamScore: -1.5
> > X-ELTE-SpamLevel: 
> > X-ELTE-SpamCheck: no
> > X-ELTE-SpamVersion: ELTE 2.0 
> > X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%	[score: 0.0000]
> > Content-Type: text/plain; charset=us-ascii
> > Content-Disposition: inline
> > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > From: Ingo Molnar <mingo@elte.hu>
> > To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > Cc: a.p.zijlstra@chello.nl, andi@firstfloor.org, fweisbec@gmail.com,
> > 	acme@redhat.com, linux-kernel@vger.kernel.org,
> > 	Jason Baron <jbaron@redhat.com>
> > Date: Mon, 13 Jul 2009 10:51:19 +0200
> > User-Agent: Mutt/1.5.18 (2008-05-17)
> > Received-SPF: neutral (mx3: 157.181.1.14 is neither permitted nor denied by domain of elte.hu) client-ip=157.181.1.14; envelope-from=mingo@elte.hu; helo=elvis.elte.hu;
> > X-Mew: tab/spc characters on Subject: are simplified.
> > 
> > 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > > Yeah, steve broke it, but then Jason fixed it again, but his 
> > > > patches might not have made it in yet.
> > > > 
> > > >   http://lkml.org/lkml/2009/7/6/313
> > > 
> > > Wow! I can obtain lock_acquire with Jason's patch,
> > > 
> > > % perf stat -e lockdep:lock_acquire sleep 1
> > > 
> > >  Performance counter stats for 'sleep 1':
> > > 
> > >            1420  lockdep:lock_acquire
> > > 
> > >     1.004953591  seconds time elapsed
> > > 
> > > I wanted this.
> > > So I don't have nothing to do.., but thanks Jason!
> > 
> > I gave some review feedback about those patches, see:
> > 
> >    http://lkml.org/lkml/2009/7/13/360
> > 
> > Once they are addressed we can try them in -tip.
> 
> Thanks! I'll try new features of perfcounters. It's interesting.
> But I told "not found" by lkml.org.
>
> Is the post you attempted to point 
> http://lkml.org/lkml/2009/7/13/36 ?

yeah. The first post should be:

 http://lkml.org/lkml/2009/7/6/313

	Ingo
