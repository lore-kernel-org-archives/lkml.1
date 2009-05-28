Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbZE1QKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbZE1QKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZE1QKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:10:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZE1QKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:10:34 -0400
Date: Thu, 28 May 2009 12:10:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       davem@davemloft.net
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
Message-ID: <20090528161028.GA20190@infradead.org>
References: <20090527180635.008102701@gentwo.org> <20090527180714.834691580@gentwo.org> <200905281316.01923.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905281316.01923.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 01:16:01PM +0930, Rusty Russell wrote:
> On Thu, 28 May 2009 03:16:59 am cl@linux-foundation.org wrote:
> > my_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).
> 
> I had this implemented earlier as as get_cpu_ptr()/__get_cpu_ptr(), to match 
> get_cpu_var() / __get_cpu_var().
> 
> But other than that nomenclature quibble, it looks fine!

my_ seems a very odd naming.  We have a lot of this_cpu naming for the
current cpu i nthe ctree, so I would suggest sticking to that.

