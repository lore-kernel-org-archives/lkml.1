Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYLTEpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYLTEpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 23:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYLTEpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 23:45:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbYLTEpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 23:45:31 -0500
Date: Fri, 19 Dec 2008 20:44:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: svaidy@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-Id: <20081219204455.5f954823.akpm@linux-foundation.org>
In-Reply-To: <20081220043638.GA24181@dirshya.in.ibm.com>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
	<20081218175622.29812.69201.stgit@drishya.in.ibm.com>
	<20081219135508.9c6217ba.akpm@linux-foundation.org>
	<20081220043638.GA24181@dirshya.in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008 10:06:38 +0530 Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> > 
> > kernel/sched.c: In function 'schedule':
> > kernel/sched.c:3679: warning: 'active_balance' may be used uninitialized in this function
> > 
> > This warning is correct - the code is buggy.
> 
> Yes this is my code bug.  I did not see the warning in sched.c.  Is
> there any build option that I need to pass in order to get -Wall
> effect?

That was just with plain old kbuild: `make allmodconfig;make'.

That warning was produced by gcc-4.0.2.  If you're using something more
recent then gcc has regressed.
