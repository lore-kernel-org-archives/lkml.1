Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZAMNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZAMNIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZAMNIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:08:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53681 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbZAMNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:08:15 -0500
Date: Tue, 13 Jan 2009 08:08:13 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: convert rcupreempt trace to seq file
In-Reply-To: <496C58C9.5080807@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0901130805500.31098@gandalf.stny.rr.com>
References: <496852DE.7080802@cn.fujitsu.com> <20090110223151.GD7061@linux.vnet.ibm.com> <20090111013940.GL12885@elte.hu> <20090111050129.GA6131@nowhere> <496C0850.8010103@cn.fujitsu.com> <20090113084905.GA5837@nowhere> <496C58C9.5080807@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 13 Jan 2009, Li Zefan wrote:
> Frederic Weisbecker wrote:

> But will trace_stat/ become a mess when there are many stat files in it ?
> 
> Does it make sense to support making subdir in trace_stat/ ?
> 

Perhaps we need to allow for a hierarchy. That is, when registering a 
trace_stat struct, allow it to have a parent. If it does, then make a 
subdirectory from the parent. But then we need a way to distinguish 
between parents (directories) and files.

a trace_stat_mkdir ?

-- Steve

