Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbXEVMRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbXEVMRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXEVMQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:16:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbXEVMQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:16:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070522061935.GA1639@ff.dom.local>
References: <20070522061935.GA1639@ff.dom.local> <20070521135048.GB4050@ff.dom.local> <20070521094224.GB1695@ff.dom.local> <7846.1179749390@redhat.com> <12203.1179756727@redhat.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org, "Robert P\. J\. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH (take 2)] Documentation/memory-barriers.txt: various fixes
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Tue, 22 May 2007 13:16:03 +0100
Message-ID: <16186.1179836163@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski <jarkao2@o2.pl> wrote:

> @@ -546,10 +546,10 @@
>  When dealing with CPU-CPU interactions, certain types of memory barrier should
>  always be paired.  A lack of appropriate pairing is almost certainly an error.
>  
> -A write barrier should always be paired with a data dependency barrier or read
> -barrier, though a general barrier would also be viable.  Similarly a read
> -barrier or a data dependency barrier should always be paired with at least an
> -write barrier, though, again, a general barrier is viable:
> +A write barrier should always be paired with a data dependency barrier or a
> +read barrier, though a general barrier would also be viable.  Similarly the
> +read barrier or the data dependency barrier should always be paired with at
> +least the write barrier, though, again, the general barrier is viable:

"A" not "the" please.

> @@ -1530,7 +1530,8 @@
>  If they're used for reference counting on an object to control its lifetime,
>  they probably don't need memory barriers because either the reference count
>  will be adjusted inside a locked section, or the caller will already hold
> -sufficient references to make the lock, and thus a memory barrier unnecessary.
> +sufficient references to make the lock, and thus the memory barrier
> +unnecessary.

Hmmm...  I'm wondering if that should actually by "a lock".

David
