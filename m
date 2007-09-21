Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbXIUN3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbXIUN3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbXIUN3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:29:15 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:44049 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbXIUN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:29:13 -0400
Date: Fri, 21 Sep 2007 09:27:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Add CRC checksum for RCU lists
In-Reply-To: <Pine.LNX.4.64.0709211516060.30810@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.58.0709210925490.24225@gandalf.stny.rr.com>
References: <1190313251.4518.14.camel@localhost.localdomain>
 <20070921140221.000a416a@twins> <Pine.LNX.4.64.0709211516060.30810@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
>
> This has been wondering me some time. Kernel oopses also use [<%p>],
> but what really for are two sort of braces needed?


I believe the notation of [<some-hex-number>] has always been a
representation of instruction pointer.  Seems that's what's used for all
outputs of instruction pointers that I've seen (well most really).

-- Steve

