Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZCQQLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZCQQLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZCQQLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:11:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbZCQQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:11:35 -0400
Date: Tue, 17 Mar 2009 12:11:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Miklos Szeredi <miklos@szeredi.hu>
cc: mingo@elte.hu, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: wrong timestamps in ftrace?
In-Reply-To: <E1Ljbp3-0005Zc-2J@pomaz-ex.szeredi.hu>
Message-ID: <alpine.DEB.2.00.0903171210510.10274@gandalf.stny.rr.com>
References: <E1Ljb4V-0005Tz-44@pomaz-ex.szeredi.hu> <20090317152753.GD13895@elte.hu> <E1Ljbp3-0005Zc-2J@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Mar 2009, Miklos Szeredi wrote:

> On Tue, 17 Mar 2009, Ingo Molnar wrote:
> > * Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > 
> > > So according to the timestamps the time difference between the first
> > > and last event was just 0.12s, which is rubbish.
> > > 
> > > This is latest git on a CoreDuo T60 notebook.  Attaching .config and
> > > dmesg.
> > 
> > There's been changes to timestamping in the tracing tree. Could you 
> > check whether latest -tip:
> > 
> >    http://people.redhat.com/mingo/tip.git/README
> > 
> > works better for you?
> 
> Unfortunately no, it's behaving exatly the same.
> 
> # uname -a
> Linux tucsk 2.6.29-rc8-tip-02571-g0fcb24f-dirty #9 SMP PREEMPT Tue Mar 17 16:53:41 CET 2009 x86_64 x86_64 x86_64 GNU/Linux

Yeah, the global clock source is there, but currently we do not have an 
option to enable it. I'm working on a patch now to fix that.

Thanks,

-- Steve

