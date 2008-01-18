Return-Path: <linux-kernel-owner+w=401wt.eu-S1765871AbYARU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765871AbYARU4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761424AbYARU4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:56:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761384AbYARU4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:56:09 -0500
Date: Fri, 18 Jan 2008 21:54:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Valdis.Kletnieks@vt.edu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
       airlied@skynet.ie, tglx@linutronix.de, akpm@linux-foundation.org,
       arjan@infradead.org, "Barnes, Jesse" <jesse.barnes@intel.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64
	identity map and kernel text
Message-ID: <20080118205415.GB9776@elte.hu>
References: <11912.1200005441@turing-police.cc.vt.edu> <20080118182727.GB10167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118182727.GB10167@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

> On Thu, Jan 10, 2008 at 05:50:41PM -0500, Valdis.Kletnieks@vt.edu wrote:
> 
>  > (Personally, I keep a copy of Arjan's "restrict devmem" patch from Fedora
>  > around, so I guess that says which camp I belong in, and the fact it's a Fedora
>  > patch and not mainstream says something too...)
> 
> The way that patch is right now (and has been for some time) is kind 
> of nasty, and could use cleaning up.  I made a half-assed attempt at 
> improving it a little over xmas, but it could rewriting from scratch. 
> That's the only reason I never bothered pushing it (and I assume, the 
> reason that Arjan didn't push it when he wrote the original).

could someone please send it into this thread so that we can have a go 
at integrating it into x86.git?

	Ingo
