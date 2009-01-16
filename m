Return-Path: <linux-kernel-owner+w=401wt.eu-S936119AbZAPCU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936119AbZAPCU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 21:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZAPCUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 21:20:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48186 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbZAPCUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 21:20:48 -0500
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Matthew Helsley <matthltc@us.ibm.com>
Reply-To: matthltc@us.ibm.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Containers <containers@lists.linux-foundation.org>
In-Reply-To: <20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	 <20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 18:20:45 -0800
Message-Id: <1232072445.7955.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 15:32 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 8 Jan 2009 22:26:46 -0800
> Paul Menage <menage@google.com> wrote:
> 
> > On Thu, Jan 8, 2009 at 9:32 PM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > >
> > > Motivation: Simply classify Applications by cgroup
> > >  When using cgroup for classifying applications, some kind of "control" or
> > >  "account" subsys must be used. For flexible use of cgroup's nature of
> > >  classifying applications, NOOP is useful. It can be used regardless of
> > >  resource accounting unit or name spaces or some controls.
> > >  IOW, NOOP cgroup allows users to tie PIDs with some nickname.
> > 
> > I agree that the idea is useful. But to me it seems to a bit
> > artificial that you still have to mount some kind of subsystem purely
> > to get the grouping, and that you can only have one such grouping.
> > 
> > I think I'd prefer the ability to mount a cgroups hierarchy without
> > *any* subsystems (maybe with "-o none"?) which would give you a
> > similar effect, but without you needing to know about a special no-op
> > subsystem, and would allow you to have multiple "no-op" groupings.
> > 
> 
> Oh, it seems better idea. Then, we need no configs and no additional subsys.
> Thank you for a hint. I'll check how I can do it.
> 
> Thanks,
> -Kame

	My feeling is this should be a signal subsystem rather than a NOOP
subsystem. Then, if users want the grouping for something besides
signaling, it doesn't matter if they don't issue any signals via the
signal.send file. Also, I think Paul's suggestion would be just as
useful for a signal subsystem.

	What do you think?

Cheers,
	-Matt Helsley

PS: Adding containers@lists.linux-foundation.org to Cc.

