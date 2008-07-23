Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYGWRnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYGWRnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYGWRnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:43:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbYGWRnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:43:02 -0400
Date: Wed, 23 Jul 2008 13:34:38 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: systemtap & backward compatibility, was Re: [RFC] systemtap: begin the process of using proper kernel APIs
Message-ID: <20080723173438.GA23758@redhat.com>
References: <y0m7ibkjrcj.fsf@ton.toronto.redhat.com> <1216325546.5515.63.camel@localhost.localdomain> <20080717202634.GI18295@redhat.com> <1216328769.5515.78.camel@localhost.localdomain> <20080717213355.GJ18295@redhat.com> <20080722140015.37628ea4@bree.surriel.com> <20080723150434.GC11191@redhat.com> <20080723082856.334f9c17__2909.60763018138$1216827051$gmane$org@infradead.org> <y0m3am0blj2.fsf@ton.toronto.redhat.com> <20080723165405.GE14846@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723165405.GE14846@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Jul 23, 2008 at 07:54:05PM +0300, Adrian Bunk wrote:
> On Wed, Jul 23, 2008 at 12:41:37PM -0400, Frank Ch. Eigler wrote:
> >...
> > In the interim (before we come up with a way of moving more
> > kernel-coupled systemtap code into kernel.org/git), would y'all
> > consider an arrangement?  Those of you who care about systemtap, and
> > are intending to make an incompatible kernel/module interface change,
> > please run the systemtap testsuite before & after.  [...]

> The number of incompatible kernel/module interface changes per
> kernel is most likely some medium three digit number.  What you have
> in mind is therefore not really feasible.

Do you think so, even if the historical pattern continues that only a
small fraction of those changes actually impact systemtap?


> But we have several levels of kernels that incorporate future stuff,
> from -rc over -next to -mm, and you could implement automated runs
> of the systemtap testsuite against the latest ones.

We do some of that already and should do more.


- FChE
