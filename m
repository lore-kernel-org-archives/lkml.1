Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYCCPsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYCCPsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYCCPse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:48:34 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:31210 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYCCPsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:48:33 -0500
Message-Id: <47CBD5CD.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 03 Mar 2008 08:41:17 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <kevin@hilman.org>, <tglx@linutronix.de>, <cminyard@mvista.com>,
       <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <acme@redhat.com>, <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [(RT RFC) PATCH v2 1/9] allow rt-mutex lock-stealing to
	includelateral priority
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160043.11268.83915.stgit@novell1.haskins.net>
 <Pine.LNX.4.58.0803030944530.18766@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0803030944530.18766@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Mar 3, 2008 at 10:13 AM, in message
<Pine.LNX.4.58.0803030944530.18766@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 


> 
> See the issue. The RT task on CPU0 may experience huge latencies.

Agreed, but equal priority threads can always cause unbounded latencies by definition.  I.e. we only guarantee to the highest thread.

> Remember, RT is worried about latencies over performance.
> If we can not ***guarantee*** a bounded latency, then, I don't care
> how good the perfomance is, it is not good enough for RT.
> 
> 
> That said, here's the compromise.
> 
> Non-RT tasks care more about overall perfomance than worst case latencies.
> So.... See imbedded:

This isn't a bad idea, but note that it means RT tasks will not get a performance boost, which is quite substantial.

Note that I have substantially cleaned up this patch for the drop I will make later this week (v3).

-Greg

