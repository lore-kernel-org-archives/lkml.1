Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbXKTW7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbXKTW7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbXKTW7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:59:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45574 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614AbXKTW7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:59:11 -0500
Date: Tue, 20 Nov 2007 23:59:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew <jackdachef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071120225908.GC24380@elte.hu>
References: <e85b9d30711201448r7b062akee8f311a56f5b1e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30711201448r7b062akee8f311a56f5b1e0@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew <jackdachef@gmail.com> wrote:

> > are you sure? The last -ck patch i can find is for .22:
> 
> >  http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/
> 
> > or have they been forward ported? (if yes, do you have an URL for that)
> 
> > (my guess is you used the 2.6.23.1 scheduler (CFS), so the improvement
> > you felt on the laptop is relative to 2.6.23-vanilla in essence - which
> > is good news.)
> 
> waninkoko over at forums.gentoo.org tries to forward port ck-patchset
> as long as he can, as you can see
> http://forums.gentoo.org/viewtopic-t-577970.html
> (see later kamikaze-sources / zen-sources / klight-sources for more info)
> ck-patchset & cfs has been an excellent combination so far ...

ok, it's great that people are picking up -ck. What i was trying to 
figure out here was whether this is a vanilla-O(1)->CFS, SD->CFS or 
CFS.23->CFS.24 comparison. It seems it's probably a CFS.23->CFS.24 
comparison. I'd also be interested in those people's impressions about 
CFSv24 who previously found SD to be superior to earlier CFS versions. 
If there's still any regression (interactivity or other) we might still 
be able to fix it before 2.6.24 is released.

	Ingo
