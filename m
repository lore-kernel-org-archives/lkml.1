Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZIWQ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZIWQ0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZIWQ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:26:13 -0400
Received: from www.tglx.de ([62.245.132.106]:53520 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbZIWQ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:26:12 -0400
Date: Wed, 23 Sep 2009 09:25:06 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Blunck <jblunck@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <4de7f8a60909230839j3d6beca8l9a677d38bc3a80d3@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0909230922160.2981@nanos>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>  <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>  <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain> 
 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>  <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>  <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>  <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> 
 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>  <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <4de7f8a60909230839j3d6beca8l9a677d38bc3a80d3@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1924910231-1253723120=:2981"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1924910231-1253723120=:2981
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 23 Sep 2009, Jan Blunck wrote:

> On Sat, Sep 19, 2009 at 12:39 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> >
> >   - disable SPARSE_IRQ, DMAR, IRQ_REMAP for -rt
> >
> 
> Do you have any reports that there is a bug in the SPARSE_IRQ code or
> why did you disable it?

Sparse irq is allocating memory in irq/preempt disabled regions which
makes preempt debug pretty unhappy. It needs some restructuring of
that code. dmar and irqremap have the same problem.

Thanks,

	tglx
--8323328-1924910231-1253723120=:2981--
