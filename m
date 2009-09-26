Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZIZQDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZIZQDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZIZQDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:03:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbZIZQDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:03:50 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to get to performance counters
References: <20090925122556.2f8bd939@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 26 Sep 2009 12:03:28 -0400
In-Reply-To: <20090925122556.2f8bd939@infradead.org> (Arjan van de Ven's message of "Fri, 25 Sep 2009 12:25:56 +0200")
Message-ID: <y0mhbuplmlr.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arjan van de Ven <arjan@infradead.org> writes:

> [...]
> There are reasons for kernel code to ask for, and use, performance counters.
> For example, in CPU freq governors this tends to be a good idea, but there
> are other examples possible as well of course.
> 
> This patch adds the needed bits to do enable this functionality; they have been
> tested in an experimental cpufreq driver that I'm working on, and the changes
> are all that I needed to access counters properly.
> [...]

For what it's worth, this sort of thing also looks useful from
systemtap's point of view.

It appears that the patch assumes that a perf counter instance is to
be associated with the "current" task.  How do you use this from your
prototype scheduler?  Do you create/attach a new one for each thread?


- FChE
