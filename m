Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZKHNF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZKHNF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZKHNF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:05:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZKHNF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:05:27 -0500
Date: Sun, 8 Nov 2009 14:05:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
Message-ID: <20091108130521.GA29728@elte.hu>
References: <20091102092214.GB8933@elte.hu>
 <20091102160410.GF27911@redhat.com>
 <20091102161248.GB15423@elte.hu>
 <20091102162234.GH27911@redhat.com>
 <20091102162941.GC14544@elte.hu>
 <20091102174208.GJ27911@redhat.com>
 <20091108113654.GO11372@elte.hu>
 <4AF6BCE5.3030701@redhat.com>
 <20091108125135.GA13099@elte.hu>
 <4AF6C112.4010601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF6C112.4010601@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 11/08/2009 02:51 PM, Ingo Molnar wrote:
> >>Maybe we should generalize paravirt-ops patching in case if (x) f() is
> >>deemed too expensive.
> >Yes, that's a nice idea. We have quite a number of 'conditional
> >callbacks' in various critical paths that could be made lighter via such
> >a technique.
> >
> > It would also free new callbacks from the 'it increases overhead 
> > even if unused' criticism and made it easier to add them.
> 
> We can take the "immediate values" infrastructure as a first step. Has 
> that been merged?

No, there were doubts about whether patching in live instructions like 
that is safe on all CPU types.

	Ingo
