Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbZJAILX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbZJAILX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbZJAILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:11:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbZJAILS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:11:18 -0400
Date: Thu, 1 Oct 2009 10:11:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mulyadi Santosa <mulyadi.santosa@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generate-cmdlist.sh should be either executable or run
	as parameter of "."
Message-ID: <20091001081102.GF7733@elte.hu>
References: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com> <20090930120822.GC7618@elte.hu> <20090930121759.GA14467@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930121759.GA14467@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0568]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Sep 30, 2009 at 02:08:22PM +0200, Ingo Molnar wrote:
> > 
> > * Mulyadi Santosa <mulyadi.santosa@gmail.com> wrote:
> > 
> > > I believe this is just a small glitch. generate-cmdlist.sh by default 
> > > should be made as executable. But since one might forgot to do it, we 
> > > could simply call it as an argument "." or "source" or even "sh -c". I 
> > > pick "."
> > > 
> > > Tested in 2.6.31
> > > 
> > > Signed-off-by: Mulyadi Santosa <mulyadi.santosa@gmail.com>
> > 
> > hm, generate-cmdlist.sh is executable in the upstream kernel repo. It 
> > apparently isnt executable on your box - why?
> 
> Whatever - we should try to avoid relying on executable bit being set. 
> umask can prevent this is tree is checkout as one user and build as 
> another user.

Fair enough - i'll queue the patch up.

	Ingo
