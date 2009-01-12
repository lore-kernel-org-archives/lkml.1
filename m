Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZALRQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZALRQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZALRQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:16:08 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:43412 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZALRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:16:06 -0500
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <1231779015.4371.138.camel@laptop>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
	 <1231778757.22806.24.camel@think.oraclecorp.com>
	 <1231779015.4371.138.camel@laptop>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 12:14:51 -0500
Message-Id: <1231780491.22806.28.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.496B7A90.00F2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 17:50 +0100, Peter Zijlstra wrote:
> > 
> > (the file stat run is total run time, so lower is better.  The other
> > numbers are files or MB per second, so higher is better)
> > 
> > For the file create run, v8 had much lower system time than v7,
> > averaging 1s of sys time per proc instead of 1.6s.
> 
> Right, how about the spread in completion time, because that is the only
> reason I tried this fairness stuff, because you reported massive
> differences there.
> 

I reran the numbers with a slightly different kernel config and they
have changed somewhat.  These are just for the 4k file create run, all
numbers in files created per second (and the numbers are stable across
runs)

v8 avg 176.90 median 171.85 std 12.49 high 215.97 low 165.54
v7 avg 169.02 median 163.77 std 16.82 high 267.95 low 157.95

-chris


