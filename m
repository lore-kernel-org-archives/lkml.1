Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYCCQCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYCCQCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYCCQCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:02:13 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:31892 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYCCQCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:02:13 -0500
Message-Id: <47CBD922.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 03 Mar 2008 08:55:30 -0700
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
Subject: Re: [(RT RFC) PATCH v2 1/9] allow rt-mutex lock-stealing
	toincludelateral priority
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160043.11268.83915.stgit@novell1.haskins.net>
 <Pine.LNX.4.58.0803030944530.18766@gandalf.stny.rr.com>
 <47CBD5CD.BA47.005A.0@novell.com>
 <Pine.LNX.4.58.0803031051410.19405@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0803031051410.19405@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Mar 3, 2008 at 10:55 AM, in message
<Pine.LNX.4.58.0803031051410.19405@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 

> On Mon, 3 Mar 2008, Gregory Haskins wrote:
> 
>> >>> On Mon, Mar 3, 2008 at 10:13 AM, in message
>> >
>> > See the issue. The RT task on CPU0 may experience huge latencies.
>>
>> Agreed, but equal priority threads can always cause unbounded latencies by 
> definition.  I.e. we only guarantee to the highest thread.
> 
> It should not when they are bounded to two separate CPUs, and are the
> highest priority tasks on those CPUS.  That will be hard to explain, how a
> the highest prio tasks bounded to a single CPU had an unbounded latency.
> With the patches presented, this can happen.

Indeed.  I see your point.  I will make this change in the next revision.

Thanks for the review!
-Greg



