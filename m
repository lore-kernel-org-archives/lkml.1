Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYGaWzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYGaWzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbYGaWzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:55:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33976
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755463AbYGaWzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:55:05 -0400
Date: Thu, 31 Jul 2008 15:55:04 -0700 (PDT)
Message-Id: <20080731.155504.167792984.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: Re: [git pull] scheduler fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080731222624.GA22426@elte.hu>
References: <20080731214352.GA22791@elte.hu>
	<20080731.150457.77077498.davem@davemloft.net>
	<20080731222624.GA22426@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 1 Aug 2008 00:26:24 +0200

> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 31 Jul 2008 23:43:52 +0200
> > 
> > > Peter Zijlstra (2):
> > >       sched: fix warning in hrtick_start_fair()
> > >       lockdep: change scheduler annotation
> > 
> > Ingo, Peter forgot to tell you but this lockdep change
> > blows up on my Niagara boxes in a way I haven't figured
> > out yet.
> 
> are you sure it's this (trivial) annotation in sched.c that blows up, 
> not your other (more invasive) changes to lockdep? This patch looked 
> fine in my testing.

I am absolutely sure, I spent the whole night yesterday trying to
debug this.
