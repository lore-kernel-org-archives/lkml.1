Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZKMIkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZKMIkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZKMIk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:40:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:17122 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbZKMIkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:40:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C6NIO9ojD4NVFt4+LURLrX7hra5qEx8R7FB5hZWISq28qLZngrrloMQfk5ZWGKChDf
         oDGgNZz98hcIr7nvU8iSCwj5g52Jz2UQzzSCByJFgbRq20zyxlaccpb/d+uqA1GlhKF9
         gqpO93oHZ+64tdobNbIQnTJZQj9niyRV6T/WM=
Date: Fri, 13 Nov 2009 09:40:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Message-ID: <20091113084030.GA5243@nowhere>
References: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp> <20091112073909.GB31719@elte.hu> <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp> <20091113081722.GA14009@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113081722.GA14009@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 09:17:22AM +0100, Ingo Molnar wrote:
> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
> > Date: Thu, 12 Nov 2009 08:39:09 +0100
> > 
> > > 
> > > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > > 
> > > > * Description
> > > > 
> > > > This patch makes the file spinlock_stats on top of the debugfs.
> > > > When user reads this file, some statistical data related to
> > > > spinlocks are printed.
> > > 
> > > hm, are you aware of the lockstat tracepoints? They do something 
> > > like this - and it utilizes perf events to report these events. See 
> > > include/trace/events/lockdep.h. Needs CONFIG_LOCK_STAT enabled.
> > >
> > 
> > Wow, I didn't know that. I'll try it.
> 
> Btw., i think we should rename that tracepoint category from 'lockdep' 
> to 'lock'. It's possible to enable them without CONFIG_PROVE_LOCKING, 
> and they arent high-overhead in that case.
> 
> 	Ingo


I have a pending patch for that somewhere. I can send it right away.

