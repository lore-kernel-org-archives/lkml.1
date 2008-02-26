Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbYBZQ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbYBZQ4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYBZQ4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:56:23 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:43898 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYBZQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:56:22 -0500
Date: Tue, 26 Feb 2008 11:55:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24.2-rt2
In-Reply-To: <47C43289.80506@siemens.com>
Message-ID: <Pine.LNX.4.58.0802261155330.10116@gandalf.stny.rr.com>
References: <1203639849.7551.4.camel@localhost.localdomain> <47C3EA1F.3030203@siemens.com>
 <47C3FF82.6060900@siemens.com> <Pine.LNX.4.58.0802261013001.6116@gandalf.stny.rr.com>
 <47C43289.80506@siemens.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Feb 2008, Jan Kiszka wrote:
> >>
> >
> > What's the NUMA topology?
>
> 4 nodes. I'm not sure if it is really NUMA related, but the same kernel
> runs that test as expected on a non-NUMA 2x2 box.
>
> > What tasks are running, and at what priorities?
>
> 40 pthreads, created with default parameters from a main thread which
> runs with default parameters as well. The threads simply run endless loops.
>
> >
> > Those three idle CPUS, should they have tasks running on them?
>
> For sure, given the overload situation of the system (40x full load vs.
> 16 cores). Neither did we fiddle with any parameter of the system
> (knowingly, its a standard openSUSE 10.3 underneath) nor did we set
> thread affinities.
>

Do you get different behaviour with 2.6.24.2?

-- Steve

