Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbZFLIE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbZFLIE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852AbZFLIEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:04:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42431 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876AbZFLIEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:04:37 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <20090612080236.GB24044@wotan.suse.de>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop> <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <20090612075427.GA24044@wotan.suse.de>
	 <1244793592.30512.17.camel@penberg-laptop>
	 <20090612080236.GB24044@wotan.suse.de>
Date: Fri, 12 Jun 2009 11:04:39 +0300
Message-Id: <1244793879.30512.19.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Fri, 2009-06-12 at 10:02 +0200, Nick Piggin wrote:
> Fair enough, but this can be done right down in the synchronous
> reclaim path in the page allocator. This will catch more cases
> of code using the page allocator directly, and should be not
> as hot as the slab allocator.

So you want to push the local_irq_enable() to the page allocator too? We
can certainly do that but I think we ought to wait for Andrew to merge
Mel's patches to mainline first, OK?

			Pekka

