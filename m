Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZCKSyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZCKSyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZCKSxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:53:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49313 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbZCKSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:53:54 -0400
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <49B7F42C.40006@zytor.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <20090310223733.GA4016@elte.hu>
	 <1236786082.3270.20.camel@localhost.localdomain> <49B7F42C.40006@zytor.com>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 18:53:48 +0000
Message-Id: <1236797629.3270.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 10:26 -0700, H. Peter Anvin wrote:
> James Bottomley wrote:
> > 
> > That goes for a huge number of drivers we have in the kernel currently,
> > and several whole architectures, so it's not a barrier to keeping
> > something maintained.
> > 
> >> nobody but you uses development kernels on it,
> > 
> > I don't think we've ever had a problem with a downstream community being
> > supported by a single upstream developer.
> > 
> 
> What "downstream community"?  There is none, and you know it.

There are actually two ... as you've heard me say before.  However,
upstream development is driven by willing maintainers, not by user
popularity contests.

> That is the whole point.  Voyager isn't just a driver -- it's an
> odd-man-out variant of the most used architecture in the world.  If it
> was just a driver, it would make sense.  However, its very existence
> forces constraints on the upstream x86 architecture, and it imposes a
> real and considerable workload on the upstream maintainers -- and that
> is not you, but on us.  When that happens with drivers for obsolete
> hardware, we remove them.

The last I heard from you was that the Subarchitecture infrastructure
was the cause of your increased workload.  Fine, it's gone.  Let me ask
again, what is the *current* problem?  This patch set moves voyager to
the x86_quirks setup as you x86 maintainers requested with the given
reason of reducing your workload.

> Hence, Ingo rather logically asks you to justify this impact on our
> workload.  I would like to know as well.  I'm personally sick of the
> extra overhead this museum piece imposes.

Well, I've already answered your workload above, but given the general
question, there are at least three reasons

     1. It's a currently supported architecture.
     2. It works.
     3. It has a committed maintainer.

It's also important to demonstrate that Linux development is based on
technical merit not personal prejudice.

James


