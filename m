Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYGVVa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYGVVa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYGVVaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:30:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYGVVav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:30:51 -0400
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.co
Subject: Re: [RFC PATCH 1/4] kmemtrace: Core implementation.
References: <1216751493-13785-1-git-send-email-eduard.munteanu@linux360.ro>
	<1216751493-13785-2-git-send-email-eduard.munteanu@linux360.ro>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 22 Jul 2008 17:28:16 -0400
In-Reply-To: <1216751493-13785-2-git-send-email-eduard.munteanu@linux360.ro> (eduard.munteanu@linux360.ro's message of "Tue, 22 Jul 2008 21:31:30 +0300")
Message-ID: <y0mvdyx7gnj.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> writes:

> kmemtrace provides tracing for slab allocator functions, such as kmalloc,
> kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected data is then fed
> to the userspace application in order to analyse allocation hotspots,
> internal fragmentation and so on, making it possible to see how well an
> allocator performs, as well as debug and profile kernel code.
> [...]

It may make sense to mention in addition that this version of
kmemtrace uses markers as the low-level hook mechanism, and this makes
the data generated directly accessible to other tracing tools such as
systemtap.  Thank you!


- FChE
