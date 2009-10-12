Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZJLU7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZJLU7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbZJLU7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:59:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637AbZJLU7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:59:00 -0400
Date: Mon, 12 Oct 2009 22:58:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, gnome-announce@gnome.org,
       linux-kernel@vger.kernel.org
Subject: Re: Announce: Sysprof 1.1.2 CPU profiler for Linux
Message-ID: <20091012205812.GF17163@elte.hu>
References: <ye8bpkxemk0.fsf@camel21.daimi.au.dk> <20091006150751.GA28868@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006150751.GA28868@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Sep 26, 2009 at 05:46:23PM +0200, Soeren Sandmann wrote:
> > Sysprof 1.1.2 is now available. This is a development release leading
> > up to a stable 1.2.0 release.
> > 
> > Sysprof is a sampling system-wide CPU profiler for Linux.  This
> > version is based on the perf counter interface in 2.6.31 kernels and
> > will not work with earlier kernels.
> 
> Btw, what is the plan for the sysprof ftrace plugin?  In general we 
> move away from ftrace plugins towards trace events and perf, and if I 
> remember correctly ftrace file format changes caused enough pain for 
> sysprof that it kept shipping it's old hacky kernel module.
> 
> Is it time to deprectate the sysprof ftrace plugin?

Yes - but it's minimal maintenance overhead so we want to keep it for 
kernel release or two, to sunset it properly.

Thanks,

	Ingo
