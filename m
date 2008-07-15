Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYGOHRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYGOHRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYGOHRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:17:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47257 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYGOHRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:17:35 -0400
Subject: Re: [RESEND PATCH] kmemtrace: SLAB hooks.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: eduard.munteanu@linux360.ro
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080714183734.GB3960@localhost>
References: <487B7F99.4060004@linux-foundation.org>
	 <1216057334-27239-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1216059588.6762.20.camel@penberg-laptop> <20080714183734.GB3960@localhost>
Date: Tue, 15 Jul 2008 10:17:18 +0300
Message-Id: <1216106238.6762.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 21:37 +0300, eduard.munteanu@linux360.ro wrote:
> > I'm okay with this approach but then you need to do
> > s/__kmem_cache_alloc/kmem_cache_alloc_trace/ or similar. In the kernel,
> > it's always the *upper* level function that doesn't have the
> > underscores.
> 
> Hmm, doesn't really make sense:
> 1. This should be called kmem_cache_alloc_notrace, not *_trace.
> __kmem_cache_alloc() _disables_ tracing.

kmem_cache_alloc_notrace() sounds good to me.

> 2. __kmem_cache_alloc is not really upper level now, since it's called
> only in kmalloc. So it's an internal function which is not supposed to
> be used by other kernel code.
> 
> Are you sure I should do this?

Yes.

