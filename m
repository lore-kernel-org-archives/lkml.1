Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYEHFe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYEHFe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYEHFeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:34:50 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:50043 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYEHFet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:34:49 -0400
Date: Thu, 8 May 2008 11:04:31 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080508053431.GB32729@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang> <20080507091748.GB30645@elte.hu> <1210181657.6525.7.camel@lappy.programming.kicks-ass.net> <1210224012.3453.105.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210224012.3453.105.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 01:20:12PM +0800, Zhang, Yanmin wrote:
> 
> On Wed, 2008-05-07 at 19:34 +0200, Peter Zijlstra wrote:
> > On Wed, 2008-05-07 at 11:17 +0200, Ingo Molnar wrote:
> > > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > > Comparing with 2.6.25, volanoMark has big regression with kernel 
> > > > 2.6.26-rc1. It's about 50% on my 8-core stoakley, 16-core tigerton, 
> > > > and Itanium Montecito.
> > > > 
> > > > With bisect, I located below patch.
> > > 
> > > thanks Yanmin, i've queued up your patch that reverts this change.
> > 
> > Is this really needed now that GROUP_SCHED defaults to 'n' ?
> > 
> > Yanmin, this is with GROUP_SCHED=y, right or is this without?
> With GROUP_SCHED=y.
> 
> I remember a similiar patch was merged into 2.6.25-rc1 and I found the similiar volanoMark
> regression, then you reverted it. Why to add it back to 2.6.26-rc1?
> 

The implementation has been changed extensively. As of now, without
proper load balancing, group scheduling is not yet fully fair, but such a
performance regression is serious, and we need to figure out why the
regression is taking place.

-- 
regards,
Dhaval
