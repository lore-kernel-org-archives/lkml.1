Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbZCOEOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbZCOEOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZCOEOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:14:38 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:33189 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751066AbZCOEOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:14:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=33J1YsXZFgONnSBmfSqd1cQO11JGrR6qNXSjsycnRm1KSgKs/WGvziVwKE9HesXDO7fakK418Emwl21+XmqscpCKQAtkq/d2hy5xUlJ0Zq0UafKSDji9nXWtAJRNxq511xt7fWP73CUrFgdcY4ibBp4Qdzc43WHmOdm7XAvItrY=  ;
X-YMail-OSG: 3yES06cVM1kbBze1_MOhERoR9i47TYpVbgZQxcsHquZIMGpVTacJaYkksBex8pU.d3MtKa1QtDkt58_0ZNJwAHNjrozZsIgFZAZM8.vh8ae53bgs1.fEs6qN.q7n_VGKEFm9uxFlDTGOChLB0nLbfeSuyUp9cduMisKqfNcp_FFy5Czhr3z4T53Wjrsq9w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sun, 15 Mar 2009 15:14:27 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903151450.51726.nickpiggin@yahoo.com.au> <200903142108.53155.phillips@phunq.net>
In-Reply-To: <200903142108.53155.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151514.28145.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 15:08:52 Daniel Phillips wrote:
> On Saturday 14 March 2009, Nick Piggin wrote:
> > On Sunday 15 March 2009 14:24:29 Daniel Phillips wrote:
> > > I expect implementing VM extents to be a brutally complex project, as
> > > filesystem extents always turn out to be, even though one tends to
> > > enter such projects thinking, how hard could this be?  Answer: harder
> > > than you think.  But VM extents would be good for a modest speedup, so
> > > somebody is sure to get brave enough to try it sometime.
> >
> > I don't think there is enough evidence to be able to make such an
> > assertion.
> >
> > When you actually implement extent splitting and merging in a deadlock
> > free manner and synchronize everything properly I wouldn't be surprised
> > if it is slower most of the time. If it was significantly faster, then
> > memory fragmentation means that it is going to get significantly slower
> > over the uptime of the kernel, so you would have to virtually map the
> > kernel and implement memory defragmentation, at which point you get even
> > slower and more complex.
>
> You can make exactly the same argument about filesystem extents, and
> we know that extents are faster there.  So what is the fundamental
> difference?

Uh, aside from all the obvious fundamental differences there are, you
can only make such an assertion if performance characteristics and
usage patterns are very similar, nevermind fundamentally different...


