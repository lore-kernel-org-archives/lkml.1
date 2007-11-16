Return-Path: <linux-kernel-owner+w=401wt.eu-S1765716AbXKPSXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765716AbXKPSXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764446AbXKPSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:22:54 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:38972 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764420AbXKPSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:22:54 -0500
Date: Fri, 16 Nov 2007 10:22:42 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 4/4] first use of sys_indirect system call
In-Reply-To: <473DDF1B.5030706@redhat.com>
Message-ID: <alpine.DEB.0.9999.0711161021420.15441@twinlark.arctic.org>
References: <200711151822.lAFIMVnJ028596@devserv.devel.redhat.com> <alpine.DEB.0.9999.0711161003310.15441@twinlark.arctic.org> <473DDF1B.5030706@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Ulrich Drepper wrote:

> dean gaudet wrote:
> > honestly i think there should be a per-task flag which indicates whether 
> > fds are by default F_CLOEXEC or not.  my reason:  third party libraries.
> 
> Only somebody who thinks exclusively about applications as opposed to
> runtimes/libraries can say something like that.  Library writers don't
> have the luxury of being able to modify any global state.  This has all
> been discussed here before.

only someone who thinks about writing libraries can say something like 
that.  you've solved the problem for yourself, and for well written 
applications, but not for the other 99.9999% of libraries out there.

i'm not suggesting the library set the global flag.  i'm suggesting that 
me as an app writer will do so.

it seems like both methods are useful.

-dean
