Return-Path: <linux-kernel-owner+w=401wt.eu-S1763474AbZE1Qi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763474AbZE1Qi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZE1QiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:38:19 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:52166 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756315AbZE1QiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:38:18 -0400
Date: Thu, 28 May 2009 12:37:54 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Christoph Hellwig <hch@infradead.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       davem@davemloft.net
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
In-Reply-To: <20090528161028.GA20190@infradead.org>
Message-ID: <alpine.DEB.1.10.0905281236490.17705@gentwo.org>
References: <20090527180635.008102701@gentwo.org> <20090527180714.834691580@gentwo.org> <200905281316.01923.rusty@rustcorp.com.au> <20090528161028.GA20190@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Christoph Hellwig wrote:

> On Thu, May 28, 2009 at 01:16:01PM +0930, Rusty Russell wrote:
> > On Thu, 28 May 2009 03:16:59 am cl@linux-foundation.org wrote:
> > > my_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).
> >
> > I had this implemented earlier as as get_cpu_ptr()/__get_cpu_ptr(), to match
> > get_cpu_var() / __get_cpu_var().
> >
> > But other than that nomenclature quibble, it looks fine!
>
> my_ seems a very odd naming.  We have a lot of this_cpu naming for the
> current cpu i nthe ctree, so I would suggest sticking to that.

So this_cpu is taken. I used THIS_CPU in earlier version
but got complaints about uppercase use. Is

this_cpu_ptr()

and

__this_cpu_ptr()

ok?


