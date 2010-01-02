Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908Ab0ABVmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0ABVmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298Ab0ABVml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:42:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53477 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab0ABVmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:42:40 -0500
Date: Sat, 2 Jan 2010 22:42:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102214232.GA23315@elte.hu>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
 <87bphc7heo.fsf@basil.nowhere.org>
 <20100102163644.GA5076@nowhere>
 <20100102174311.GA30016@basil.fritz.box>
 <20100102190213.GC5076@nowhere>
 <20100102192337.GB30016@basil.fritz.box>
 <20100102201138.GF5076@nowhere>
 <20100102203305.GC30016@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102203305.GC30016@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.2
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.2 required=5.9 tests=BAYES_00,FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.2 FH_DATE_PAST_20XX      The date is grossly in the future.
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Sat, Jan 02, 2010 at 09:11:39PM +0100, Frederic Weisbecker wrote:
> > I've never lost any datas since I began this work. And
> > I run it every day. If I had experienced lock inversions,
> > and sometimes soft lockups, I did not experienced serious
> > damages. It's a journalized filesystem that can fixup the things
> > pretty well.
> 
> So are you confident that 2.6.33 will not have regular soft-lockups for 
> reiserfs users?

Well, are you confident that your hardware-poison changes in v2.6.33 will not 
have any user triggerable bugs? It's a pretty silly question IMO because you 
can never be 100% confident.

What matters is for the changes to be sane and clean, for there to be no known 
regression and for any reported bugs to be fixed speedily. Which Frederic is 
doing in an utmost excellent way ...

Thanks,

	Ingo
