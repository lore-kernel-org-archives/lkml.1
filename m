Return-Path: <linux-kernel-owner+w=401wt.eu-S1766953AbXEBRto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766953AbXEBRto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766955AbXEBRto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:49:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48155 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766953AbXEBRtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:49:42 -0400
Date: Wed, 2 May 2007 19:49:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070502174940.GA9089@one.firstfloor.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502094707.4197ab7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 09:47:07AM -0700, Andrew Morton wrote:
> On Wed, 2 May 2007 12:44:13 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > It is currently used as an instrumentation infrastructure for the LTTng
> > > tracer at IBM, Google, Autodesk, Sony, MontaVista and deployed in
> > > WindRiver products.  The SystemTAP project also plan to use this type of
> > > infrastructure to trace sites hard to instrument. The Linux Kernel
> > > Markers has the support of Frank C. Eigler, author of their current
> > > marker alternative (which he wishes to drop in order to adopt the
> > > markers infrastructure as soon as it hits mainline).
> > 
> > All of the above don't use mainline kernels.
> 
> That's because they have to add a markers patch!

I meant they use very old kernels. Their experiences don't apply
to mainline bitrottyness.

> > That doesn't constitute using it.
> 
> Andi, there was a huge amount of discussion about all this in September last
> year (subjects: *markers* and *LTTng*). The outcome of all that was, I
> believe, that the kernel should have a static marker infrastructure.

I have no problem with that in principle; just some doubts about
the current proposed implementation: in particular its complexity.
And also I think when something is merged it should have some users in tree.

-Andi

