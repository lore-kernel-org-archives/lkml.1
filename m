Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXF1Jrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXF1Jrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbXF1Jrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:47:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:40014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbXF1Jrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:47:42 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch-mm 00/28] High resolution timer updates and x86_64 support - V3
Date: Thu, 28 Jun 2007 11:47:04 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de> <20070628024233.8e29a5bd.akpm@linux-foundation.org>
In-Reply-To: <20070628024233.8e29a5bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281147.04556.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007 11:42:33 Andrew Morton wrote:

> > The patch set has been tested in the -hrt and -rt trees for quite a while
> > and the initial problems have been sorted out. Thanks to the folks from the
> > PowerTop project for testing and feedback.
> 
> hrm.  Looks like none of your testers have HPET_ID_LEGSUP hardware.  

AFAIK it's only on IBM Summit. You have such a box?

> btw, if you want to know why I go on and on about crappy commenting, try to
> work out from the kernel source code what HPET_ID_LEGSUP is, and why it
> gets special treatment.  It is not possible.  This is not maintainable
> code.

We have a reference somewhere to the HPET spec.

-Andi
