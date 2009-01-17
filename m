Return-Path: <linux-kernel-owner+w=401wt.eu-S1765584AbZAQXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765584AbZAQXNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbZAQXNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:13:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39289 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760032AbZAQXNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:13:37 -0500
Date: Sat, 17 Jan 2009 18:53:08 +0100
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       J?rn Engel <joern@logfs.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090117175308.GB1409@ucw.cz>
References: <1231584446.3685.21.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231584446.3685.21.camel@johannes>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ wireless-testing/lib/btree.c	2009-01-10 11:41:47.000000000 +0100
> @@ -0,0 +1,797 @@
> +/*
> + * lib/btree.c	- Simple In-memory B+Tree
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2007-2008 Joern Engel <joern@logfs.org>
> + * Bits and pieces stolen from Peter Zijlstra's code, which is
> + * Copyright 2007, Red Hat Inc. Peter Zijlstra <pzijlstr@redhat.com>
> + * GPLv2
> + *
> + * see http://programming.kicks-ass.net/kernel-patches/vma_lookup/btree.patch
> + *
> + * A relatively simple B+Tree implementation.  I have written it as a learning
> + * excercise to understand how B+Trees work.  Turned out to be useful as well.
> + *
> + * B+Trees can be used similar to Linux radix trees (which don't have anything
> + * in common with textbook radix trees, beware).  Prerequisite for them working
> + * well is that access to a random tree node is much faster than a large number
> + * of operations within each node.

should be 'much slower'?

Because otherwise I don't get it.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
