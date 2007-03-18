Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXCRH6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXCRH6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 03:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXCRH6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 03:58:37 -0400
Received: from 1wt.eu ([62.212.114.60]:1249 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXCRH6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 03:58:37 -0400
Date: Sun, 18 Mar 2007 08:58:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: Radoslaw Szkodzinski <astralstorm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, ck@vds.kolivas.org,
       Avi Kivity <avi@argo.co.il>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
Subject: Re: [ck] Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070318075807.GA3760@1wt.eu>
References: <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com> <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org> <20070318052439.GT943@1wt.eu> <1174199171.8543.1.camel@Homer.simpson.net> <f44c5fdf0703172354o935e140p8a3e64411d3ffa0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44c5fdf0703172354o935e140p8a3e64411d3ffa0a@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 07:54:20AM +0100, Radoslaw Szkodzinski wrote:
> On 3/18/07, Mike Galbraith <efault@gmx.de> wrote:
> >On Sun, 2007-03-18 at 06:24 +0100, Willy Tarreau wrote:
> >
> >> Maybe we're all discussing the problem because we have reached the point
> >> where we need two types of schedulers : one for the desktop and one for
> >> the servers. After all, this is already what is proposed with preempt,
> >> it would make sense provided they share the same core and avoid ifdefs
> >> or unused structure members. Maybe adding OPTIONAL unfairness to RSDL
> >> would help some scenarios, but in any case it is important to retain
> >> the default fairness it provides.
> >
> >Bingo.
> >
> 
> Sounds like Staircase's interactive mode switch, except this actually
> requires writing additional code.
> 
> The per-user system would also be nice for servers, provided there are
> CPU/disc IO/swapper/... quotas or priorities at least.

This is too hard to adjust. Imagine what would happen to your hundreds of
apache processes when the "backup" user will start the rsync or tar+gzip,
or when user "root" will start rotating and compressing the logs. Being
able to group processes may be useful on servers, but it should be enabled
on purpose by the admin.

Willy

