Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbZFWVez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbZFWVez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbZFWVeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:34:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:55840 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273AbZFWVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:34:19 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 14:28:17 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
       avi@redhat.com, kvm@vger.kernel.org, ghaskins@novell.com,
       rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
In-Reply-To: <20090623142909.42776e75.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906231426020.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com> <20090623131848.b876d42e.akpm@linux-foundation.org> <alpine.DEB.1.10.0906231400010.17001@makko.or.mcafeemobile.com>
 <20090623142909.42776e75.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Andrew Morton wrote:

> > > > +struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx)
> > > > +{
> > > > +	kref_get(&ctx->kref);
> > > > +	return ctx;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(eventfd_ctx_get);
> > > 
> > > doesn't match the code.
> 
> You appear to have not seen the above sentence.

I saw that and have already fixed it. Sorry I missed the ACK.



> yeah, I never trust people.  You might lose the email or jump on a
> plane and disappear for three weeks, then it all gets forgotten about
> and lost.

Jumping on a plane. Check. Disappearing for 6 weeks. Check. ;)


- Davide


