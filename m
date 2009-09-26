Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbZIZSc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbZIZSc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIZScz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:32:55 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48089 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZIZScz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:32:55 -0400
Date: Sun, 27 Sep 2009 00:02:46 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "Frank Ch. Eigler" <fche@redhat.com>, peterz@infradead.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20090926183246.GA4141@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mhbuplmlr.fsf@fche.csb>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 12:03:28PM -0400, Frank Ch. Eigler wrote:
> 
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > [...]
> > There are reasons for kernel code to ask for, and use, performance counters.
> > For example, in CPU freq governors this tends to be a good idea, but there
> > are other examples possible as well of course.
> > 
> > This patch adds the needed bits to do enable this functionality; they have been
> > tested in an experimental cpufreq driver that I'm working on, and the changes
> > are all that I needed to access counters properly.
> > [...]
> 
> For what it's worth, this sort of thing also looks useful from
> systemtap's point of view.

Wouldn't SystemTap be another user that desires support for multiple/all CPU
perf-counters (apart from hw-breakpoints as a potential user)? As Arjan pointed
out, perf's present design would support only a per-CPU or per-task counter;
not both.

Thanks,
K.Prasad

