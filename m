Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZAVMH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZAVMH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZAVMHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:07:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZAVMHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:07:11 -0500
Date: Thu, 22 Jan 2009 13:06:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090122120620.GA24295@elte.hu>
References: <20090121185021.GA8852@elte.hu> <20090122112238.GC7131@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122112238.GC7131@nb.net.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Karel Zak <kzak@redhat.com> wrote:

> On Wed, Jan 21, 2009 at 07:50:21PM +0100, Ingo Molnar wrote:
> >  - The 'perfstat' utility (ex 'timec') has been updated:
> > 
> >       http://people.redhat.com/mingo/perfcounters/perfstat.c
> 
>  what are your planning to do with this utility? We can merge it into 
>  util-linux-ng.

That would be nice to do, if/once/when the subsystem and the syscall 
itself is merged upstream. The syscall ABI might change until that 
happens.

	Ingo
