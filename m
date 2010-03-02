Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0CBKbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:31:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45684 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0CBKbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:31:05 -0500
Date: Tue, 2 Mar 2010 11:30:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Avi Kivity <avi@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>, ming.m.lin@intel.com,
       sheng.yang@intel.com, Jes Sorensen <Jes.Sorensen@redhat.com>,
       KVM General <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: KVM usability
Message-ID: <20100302103045.GA28310@elte.hu>
References: <4B87A6BF.3090301@redhat.com>
 <20100226111734.GE7463@elte.hu>
 <4B8813F2.8090208@redhat.com>
 <20100227105643.GA17425@elte.hu>
 <4B893B2B.40301@redhat.com>
 <20100227172546.GA31472@elte.hu>
 <4B8BEFC7.2040000@redhat.com>
 <20100301174106.GB2362@ghostprotocols.net>
 <4B8C0778.8050908@redhat.com>
 <20100301205620.GA26151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301205620.GA26151@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Here's our experience with tools/perf/. Hosting the project in the kernel 
> proper helped its quality immensely:
> 
>  - It's much easier to synchronize new features on the kernel side and on the
>    user-space side. The two go hand in hand - they are often implemented in
>    the same patch.

Just look at an example from today, a perf+KVM feature patch posted by Yanmin 
Zhang:

  http://www.mail-archive.com/kvm@vger.kernel.org/msg29770.html

That single patch implements the following "perf kvm" commands:

  perf kvm top
  perf kvm record
  perf kvm report
  perf kvm diff

Both the kernel-space and the user-space changes are in that single patch.

Anyone who'd like to try it out can apply it and get an updated kernel plus 
updated tooling and can start profiling KVM guests straight away. You just 
check out the kernel, apply the patch and that's it - you can go. It doesnt 
get any more convenient than that to do development.

Such kind of a unified repository is a powerful concept, and we make use of 
those aspects of tools/perf/ every day. You could only pry it out of our cold, 
dead fingers ;-)

Btw., this is one of the things that FreeBSD does right - and i believe it is 
one of the technical concepts behind Apple's success as well. Apple, with a 
tenth's of Linux's effective R&D budget can consistently out-develop Linux. I 
think that's in part due to there not being a strict chinese wall between the 
Apple kernel, libraries and applications - it's one coherent project where 
everyone is well-connected to each piece, with no artificial project-cultural 
boundaries and barriers. People can and do move between those areas of the 
larger "Apple" project to achieve their goals - regardless of how many 
components need touching for a given area of interest.

IMHO we should learn from that - while we are good in many areas there's 
always aspects of Linux that can be improved. But i digress.

Thanks,

	Ingo
