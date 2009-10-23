Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZJWLTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZJWLTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 07:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZJWLTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 07:19:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZJWLTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 07:19:34 -0400
Date: Fri, 23 Oct 2009 13:19:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ryota Ozaki <ozaki.ryota@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       KVM ML <kvm@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip] sched, cpuacct: fix niced guest time accounting
Message-ID: <20091023111920.GA5886@elte.hu>
References: <5e93dcec0910200800q2e156fd3v324632efcf136f5e@mail.gmail.com> <4AE02A1B.6020700@redhat.com> <5e93dcec0910220512x50788f59u56e6493778093c7@mail.gmail.com> <5e93dcec0910220836x7f798d45w299129e0c80ed5d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e93dcec0910220836x7f798d45w299129e0c80ed5d1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ryota Ozaki <ozaki.ryota@gmail.com> wrote:

> Hi list,
> (CC: Ingo and Avi)
> 
> CPU time of a guest is always accounted in 'user' time
> without concern for the nice value of its counterpart
> process although the guest is scheduled under the nice
> value.
> 
> This patch fixes the defect and accounts cpu time of
> a niced guest in 'nice' time as same as a niced process.
> 
> And also the patch adds 'guest_nice' to cpuacct. The
> value provides niced guest cpu time which is like 'nice'
> to 'user'.
> 
> This patch has already reviewed and acked by Avi on KVM ML.
> 
> The original discussions can be found here.
> http://www.mail-archive.com/kvm@vger.kernel.org/msg23982.html
> http://www.mail-archive.com/kvm@vger.kernel.org/msg23860.html

your patch is line-wrapped and does not apply (possibly due to more 
whitespace damage).

Please consult Documentation/email-clients.txt and send a patch against 
latest -tip :

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
