Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbZIXPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbZIXPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZIXPQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:16:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZIXPQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:16:57 -0400
Date: Thu, 24 Sep 2009 17:16:58 +0200
From: Jan Blunck <jblunck@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31-rt11
Message-ID: <20090924151658.GQ18706@bolzano.suse.de>
References: <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain> <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain> <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain> <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain> <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain> <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <4de7f8a60909230839j3d6beca8l9a677d38bc3a80d3@mail.gmail.com> <alpine.LFD.2.00.0909230922160.2981@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0909230922160.2981@nanos>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, Thomas Gleixner wrote:

> 
> 
> On Wed, 23 Sep 2009, Jan Blunck wrote:
> 
> > On Sat, Sep 19, 2009 at 12:39 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > We are pleased to announce the next update to our new preempt-rt
> > > series.
> > >
> > >   - disable SPARSE_IRQ, DMAR, IRQ_REMAP for -rt
> > >
> > 
> > Do you have any reports that there is a bug in the SPARSE_IRQ code or
> > why did you disable it?
> 
> Sparse irq is allocating memory in irq/preempt disabled regions which
> makes preempt debug pretty unhappy. It needs some restructuring of
> that code. dmar and irqremap have the same problem.

Is this with the patch I sent on Aug 31:
[PATCH] Allocate memory before disabling memory in irq_to_desc_alloc_node()

Thanks,
Jan
