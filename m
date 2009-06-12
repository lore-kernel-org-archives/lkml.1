Return-Path: <linux-kernel-owner+w=401wt.eu-S1764533AbZFLOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764533AbZFLOXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763729AbZFLOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:23:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:57842 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764146AbZFLOX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:23:27 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20090612141118.GK32105@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop> <20090612125335.GH31845@elte.hu>
	 <1244812224.7172.146.camel@pasglop> <1244813397.7172.156.camel@pasglop>
	 <20090612134940.GD32105@elte.hu> <1244815574.7172.171.camel@pasglop>
	 <20090612141118.GK32105@elte.hu>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 00:23:02 +1000
Message-Id: <1244816582.7172.175.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 16:11 +0200, Ingo Molnar wrote:
> > Maybe. But maybe it's representative... so far in this merge 
> > window, 100% of the powerpc build and runtime breakage upstream 
> > comes from stuff that didn't get into -next before.
> 
> But that's axiomatic, isnt it? linux-next build-tests PowerPC as the 
> first in the row of tests - so no change that was in linux-next can 
> ever cause a build failure on PowerPC, right?

I'd have to check with Stephen but I think linux-next tests a whole
bunch of archs each round. Anyway, the idea is, just don't get things
upstream before the at least had a chance to go through that little bit
of integration testing .. Is it -that- hard ?

Oh and before you ask me, yes, I do the same mistakes, and I have been
caught too merging things at the last minute that ended up broken and
that could have been caught by -next... I'm just trying to advocate the
idea that we all try to improve in that area :-)

Cheers,
Ben.


