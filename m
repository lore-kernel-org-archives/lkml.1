Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121Ab0ABWTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0ABWTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 17:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685Ab0ABWTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 17:19:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab0ABWTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 17:19:23 -0500
Date: Sat, 2 Jan 2010 23:18:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102221857.GA2901@elte.hu>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
 <87bphc7heo.fsf@basil.nowhere.org>
 <20100102163644.GA5076@nowhere>
 <20100102174311.GA30016@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102174311.GA30016@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 3.4
X-ELTE-SpamLevel: sss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=3.4 required=5.9 tests=FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.4 FH_DATE_PAST_20XX      The date is grossly in the future.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > I only have reiserfs partitions in my laptop and my testbox,
> > nothing else. And that because I'm now maintaining it de facto.
> 
> AFAIK it's widely used in SUSE installations. It was the default for a long 
> time.
> 
> And right now as in 2.6.32 it's in a state of "may randomly 
> explode/deadlock". And no clear path out of it. Not good.

Btw. that's quite weird as nothing of substance happened in fs/reiserfs in 
v2.6.32:

 $ git shortlog v2.6.31..v2.6.32 fs/reiserfs/
 Alexey Dobriyan (2):
       const: make struct super_block::dq_op const
       const: make struct super_block::s_qcop const

( There might be VFS core interactions perhaps - but nothing i've seen seems
  to correlate with your claims and that's quite weird. )

There's always reports about filesystem corruptions (file data cache is 
statistically the most likely thing to get corrupted by borderline hw failures 
such as RAM failures or DMA corruptions), but i've seen nothing out of the 
ordinary for v2.6.32 with reiserfs. (and the v2.6.33-rc1 bits are not yet 
merged in distro kernels)

So please substantiate your claims: URLs, distro bugzilla entries, etc.

Thanks,

	Ingo
