Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYC1Pdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYC1Pdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYC1Pdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:33:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYC1Pdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:33:44 -0400
Date: Fri, 28 Mar 2008 11:31:52 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328153152.GA23249@redhat.com>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com> <20080328101500.GF30863@elte.hu> <y0mabkjvufd.fsf@ton.toronto.redhat.com> <20080328144116.GG29218@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080328144116.GG29218@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Mar 28, 2008 at 03:41:16PM +0100, Ingo Molnar wrote:
> > > [...]  furthermore, and because it's Friday again, let me remind 
> > > folks that SystemTap has an even more significant bloat problem: the 
> > > fact that it needs a huge download: [...the dwarf debugging 
> > > information...]
> > 
> > It's a problem, and there are a few improvements under way or being 
> > contemplated: [...]
> 
> it's been the primary usability problem ever since SystemTap has been 
> incepted 3 years ago. [...]

This complaint is particularly rich, seeing how you constantly try to
shoot down patches that would reduce systemtap's need for this, such
as markers.  And no, dyn-ftrace is not a complete substitute.  See how
many of the markers in mathieu's lttng suite occur at places *other*
than function entry points.  See how many require parameters other
than what may already sit in registers.

We in systemtap land have always had to make do with whatever was in
the kernel.  There was very little other than kprobes 3 years ago.  Of
newer facilities such as markers, ftrace, perfmon2 (I hope), and a
bunch of other little tracer thingies, all those that provide a usable
callback style interface can be exposed to systemtap.  The more the
merrier, and the less we'd have to resort to the lowest-level
kprobes/dwarf stuff.  Please help rather than obstruct.


- FChE
