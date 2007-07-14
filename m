Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXGNK46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXGNK46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXGNK4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:56:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbXGNK4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:56:49 -0400
Subject: Re: [realtime-preempt] [x86_64] HR_TIMER and/or DYNTICKS cause an
	early boot freeze
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Maathuis <madman2003@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6d4bc9fc0707140349y1874dc1ag75075c84137c4d6d@mail.gmail.com>
References: <6d4bc9fc0707130702l41f58c20l72423be27292d884@mail.gmail.com>
	 <1184337551.20032.89.camel@twins>
	 <6d4bc9fc0707140349y1874dc1ag75075c84137c4d6d@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 12:56:42 +0200
Message-Id: <1184410602.5284.40.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 12:49 +0200, Maarten Maathuis wrote:
> Were can -rt3 be found?

http://lkml.org/lkml/2007/7/13/159

> On 7/13/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2007-07-13 at 16:02 +0200, Maarten Maathuis wrote:
> > > I have determined that version 2.6.22.1-rt2 freeze after:
> > >
> > > NET: Register protocol family 2
> > >
> > > This is very early in the boot stage, and i cannot determine what
> > > exactly causes it.
> > >
> > > It happens if either high resolution timers or dynamic ticks are active.
> > >
> > > I have included the config file that does work (so dynticks and
> > > hr_timers are disabled).
> > >
> > > Please CC any replies, as i am not a member of this mailinglist.
> >
> > Try -rt3, that solved this issue for me.
> >
> >

