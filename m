Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZI3MId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZI3MId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZI3MIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:08:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbZI3MIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:08:31 -0400
Date: Wed, 30 Sep 2009 14:08:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mulyadi Santosa <mulyadi.santosa@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generate-cmdlist.sh should be either executable or run
	as parameter of "."
Message-ID: <20090930120822.GC7618@elte.hu>
References: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4933]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mulyadi Santosa <mulyadi.santosa@gmail.com> wrote:

> I believe this is just a small glitch. generate-cmdlist.sh by default 
> should be made as executable. But since one might forgot to do it, we 
> could simply call it as an argument "." or "source" or even "sh -c". I 
> pick "."
> 
> Tested in 2.6.31
> 
> Signed-off-by: Mulyadi Santosa <mulyadi.santosa@gmail.com>

hm, generate-cmdlist.sh is executable in the upstream kernel repo. It 
apparently isnt executable on your box - why?

	Ingo
