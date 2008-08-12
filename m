Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYHLPcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYHLPcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYHLPcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:32:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:33538 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYHLPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=ZQKk3KoES4BXU104D9KccjYH5pyDXbRkEmWni5LrMQC9k4f/0KMblg994KS/x+MTqa
         JiVBHHhyxDDqkrbf9JSbavvdT18CNQUkv2N0eMtLncZmC3ZwP8D8o0drNdc12aecXzoS
         +GIrLSI4cYdTX+hvp/wKtXY0vQt2OGIWyfVoA=
Date: Tue, 12 Aug 2008 18:29:54 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, mathieu.desnoyers@polymtl.ca,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       mpm@selenic.com, rostedt@goodmis.org, tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
Message-ID: <20080812152954.GB5973@localhost>
References: <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro> <48A046F5.2000505@linux-foundation.org> <1218463774.7813.291.camel@penberg-laptop> <48A048FD.30909@linux-foundation.org> <1218464177.7813.293.camel@penberg-laptop> <48A04AEE.8090606@linux-foundation.org> <1218464557.7813.295.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218464557.7813.295.camel@penberg-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 05:22:37PM +0300, Pekka Enberg wrote:
> On Mon, 2008-08-11 at 09:21 -0500, Christoph Lameter wrote:
> > Pekka Enberg wrote:
> > 
> > > The function call is supposed to go away when we convert kmemtrace to
> > > use Mathieu's markers but I suppose even then we have a problem with
> > > inlining?
> > 
> > The function calls are overwritten with NOPs? Or how does that work?
> 
> I have no idea. Mathieu, Eduard?

Yes, the code is patched at runtime. But AFAIK markers already provide
this stuff (called "immediate values"). Mathieu's tracepoints also do
it. But it's not available on all arches. x86 and x86-64 work as far as
I remember.

