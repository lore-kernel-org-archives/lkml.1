Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYAQSp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYAQSp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYAQSpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:45:51 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:37220 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYAQSpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:45:50 -0500
Date: Thu, 17 Jan 2008 13:45:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Wolfgang Grandegger <wg@grandegger.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1
In-Reply-To: <1200594655.18731.148.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0801171344290.28350@gandalf.stny.rr.com>
References: <1200544050.318.18.camel@localhost.localdomain> 
 <478F2A46.5070506@grandegger.com>  <1200586632.18731.141.camel@imap.mvista.com>
  <478F9BCE.4030301@grandegger.com> <1200594655.18731.148.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jan 2008, Daniel Walker wrote:

>
> On Thu, 2008-01-17 at 19:17 +0100, Wolfgang Grandegger wrote:
> > [    0.733248] TCP bind hash table entries: 2048 (order: 3, 57344
> > bytes)
> > [    0.741132] TCP: Hash tables configured (established 2048 bind
> > 2048)
> > [    0.747981] TCP reno registered
> > [    0.805896] krcupreemptd setsched 0
> > [    0.809657]   prio = 98
>
> That's interesting .. You chould try running cyclictest at priority 99
> to eliminate other threads that might get involved (using -p99 instead
> of -p80 , I think) ..
>

But, anotherthing to try is disabling CONFIG_PREEMPT_RCU_BOOST, and see if
that fixes anything.

-- Steve

