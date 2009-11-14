Return-Path: <linux-kernel-owner+w=401wt.eu-S932667AbZKNAyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbZKNAyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbZKNAyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:54:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbZKNAyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:54:11 -0500
Date: Sat, 14 Nov 2009 01:53:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
Message-ID: <20091114005300.GA17512@elte.hu>
References: <20091023233746.128967000@alcatraz.americas.sgi.com>
 <87tyxmy6x6.fsf@basil.nowhere.org>
 <4AE5E48F.6020408@sgi.com>
 <20091026215544.GA3355@basil.fritz.box>
 <4AEB3D95.50300@sgi.com>
 <4AEEBE65.3070202@linux.intel.com>
 <4AEF3143.2030701@sgi.com>
 <20091112222200.GA19109@redhat.com>
 <4AFC92DD.3020105@zytor.com>
 <4AFD84E9.1010908@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFD84E9.1010908@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> H. Peter Anvin wrote:
> >On 11/12/2009 02:22 PM, Dave Jones wrote:
> >>But I don't disagree with Andi either, that it's not particularly useful,
> >>and we can get all this from userspace in /proc/cpuinfo, or x86info.
> >>
> >
> > I personally don't think it's useful at all.  It gives information 
> > about the processor which can be obtained from other sources.  What 
> > we want is enough information that the CPU can be unambiguously 
> > identified, so that when someone posts dmesg we can tell what 
> > machine they came from.
> 
> Can we say the same thing about the sched debug messages?  It's even 
> more painful because the number of lines output is exponential to the 
> number of cpus.

Yeah - but instead of getting rid of them please tie them to a (default 
off) debug switch. There's been the occasional crash where they were 
useful.

	Ingo
