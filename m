Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbXF1Kk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbXF1Kk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbXF1Kkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:40:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910AbXF1Kks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:40:48 -0400
Date: Thu, 28 Jun 2007 03:39:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch-mm 00/28] High resolution timer updates and x86_64
 support - V3
Message-Id: <20070628033947.8c614b55.akpm@linux-foundation.org>
In-Reply-To: <200706281147.04556.ak@suse.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	<20070628024233.8e29a5bd.akpm@linux-foundation.org>
	<200706281147.04556.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 11:47:04 +0200 Andi Kleen <ak@suse.de> wrote:

> On Thursday 28 June 2007 11:42:33 Andrew Morton wrote:
> 
> > > The patch set has been tested in the -hrt and -rt trees for quite a while
> > > and the initial problems have been sorted out. Thanks to the folks from the
> > > PowerTop project for testing and feedback.
> > 
> > hrm.  Looks like none of your testers have HPET_ID_LEGSUP hardware.  
> 
> AFAIK it's only on IBM Summit. You have such a box?

Intel Nocona SDV thing.  Old.

> > btw, if you want to know why I go on and on about crappy commenting, try to
> > work out from the kernel source code what HPET_ID_LEGSUP is, and why it
> > gets special treatment.  It is not possible.  This is not maintainable
> > code.
> 
> We have a reference somewhere to the HPET spec.

The HPET spec won't tell me why HPET_ID_LEGSUP hpets get a kmalloc in Linux
but the !HPET_ID_LEGSUP ones don't.

