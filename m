Return-Path: <linux-kernel-owner+w=401wt.eu-S1764350AbZFQH3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764350AbZFQH3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZFQH3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:29:03 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:26781 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZFQH3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:29:02 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/core] perf record/report: Add call graph /
 call chain profiling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090616025750.GB6057@nowhere>
References: <tip-3efa1cc99ec51bc7a7ae0011a16619fd20dbe6ea@git.kernel.org>
	 <20090616025750.GB6057@nowhere>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 09:29:04 +0200
Message-Id: <1245223744.13761.21570.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 04:57 +0200, Frederic Weisbecker wrote:
> > +struct ip_chain_event {
> > +     __u16 nr;
> 
> 
> 
> Is it needed to have the nr encoded in the ip_chain?
> We can already find it by doing kernel + user.

strictly speaking: hv+kernel+user
but yeah, we could possibly replace it with another context, guest
perhaps.

suggestions anyone?

> 
> > +     __u16 hv;
> > +     __u16 kernel;
> > +     __u16 user;
> > +     __u64 ips[];
> > +};

