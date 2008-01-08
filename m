Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYAHWTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYAHWTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYAHWRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:17:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54298 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbYAHWRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:17:20 -0500
Date: Tue, 8 Jan 2008 23:17:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in arch/x86/ia32/ia32_aout.c
Message-ID: <20080108221722.GA27698@uranus.ravnborg.org>
References: <20080108203233.01bb5c7f@paolo-desktop> <20080108150439.6388028e@bree.surriel.com> <20080108215247.GE14829@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108215247.GE14829@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Most of these kernel changes would probably get in the way of real 
> > development, making patches reject that would otherwise apply.
> 
> I'm curious, in what way would they interfere?

Developer A work one some complicated stuff in foo.c which is
not yet -mm fooder.

Developer B submits and have applied a massive cleanup to some of the
files touced by Developer A's patch.

Developer A now needs to fix up his stuff.

Reminder: Not everyone writes their stuff in 48 hours before it
is lkml ready.

> 
> Firstly, anyone with a forked kernel with outstanding patches that are 
> not in x86.git only has themselves to blame. We want to actively 
> discourage forking and sitting on patches too long.

Curious - what is the purpose of the x86.git tree these days?

	Sam
