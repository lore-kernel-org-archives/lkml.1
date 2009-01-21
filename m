Return-Path: <linux-kernel-owner+w=401wt.eu-S1763403AbZAUEib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763403AbZAUEib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZAUEiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:38:22 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:58053 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbZAUEiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:38:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlSeOKeZSd/Qb1CGfRXq96aKLhLBQztAQxoMfRqd93I+P2zrNtALwCSaPVWy4n2/N3
         ENGayyZ5Vwu0yOUFxUj+Cuu3x+j6UqAksX4QZ8JlPnJb1W6oi1Cn5j8dLLmjaRu2ZXTm
         DEOUGAlfS1Ajecn3cpD4tA15NQqZ+d2hgJjSg=
MIME-Version: 1.0
In-Reply-To: <20090121002507.GA12616@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal>
	 <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal>
	 <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal>
	 <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk>
	 <20090120232748.GA10605@Krystal> <20090121002507.GA12616@Krystal>
Date: Tue, 20 Jan 2009 23:38:19 -0500
Message-ID: <720e76b80901202038p1e1f929ci56e9f35c5a629c88@mail.gmail.com>
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
From: Ben Gamari <bgamari@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 7:25 PM, Mathieu Desnoyers
<mathieu.desnoyers@polymtl.ca> wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
>
> As a side-note : I'd like to have my results confirmed by others.

Well, I think the (fixed) patch did help to some degree (I haven't
done fio benchmarks to compare against yet). Unfortunately, the I/O
wait time problem still remains. I have been waiting 3 minutes now for
evolution to start with 88% I/O wait time yet no visible signs of
progress. I've confirmed I'm using the CFQ scheduler, so that's not
the problem.

Also, Jens, I'd just like to point out that the problem is
reproducible across all schedulers. Does your patch seek to tackle a
problem specific to the CFQ scheduler, leaving the I/O wait issue for
later? Just wondering.

I'll post some benchmarks numbers once I have them. Thanks,

- Ben
