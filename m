Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYCWHP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYCWHP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 03:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYCWHPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 03:15:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:48418 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752867AbYCWHPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 03:15:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+2OAlwX6G2HGNjiaC2b0fxVn64937MKgCMDaJdlj
	qBsO/3hOWuvPhV
Subject: Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47E5FAF2.2060508@colorfullife.com>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
	 <1206186832.4545.1.camel@marge.simson.net>
	 <47E51637.8060102@colorfullife.com>
	 <1206214504.4538.8.camel@marge.simson.net>
	 <47E5FAF2.2060508@colorfullife.com>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 08:15:11 +0100
Message-Id: <1206256511.4367.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-03-23 at 07:38 +0100, Manfred Spraul wrote:
> Mike Galbraith wrote:
> > On Sat, 2008-03-22 at 15:22 +0100, Manfred Spraul wrote:
> >   
> >> Mike Galbraith wrote:
> >>     
> >>> Total: 4691827                                Total: 3942000
> >>>   
> >>>       
> >> Thanks. Unfortunately the test was buggy, it bound the tasks to the 
> >> wrong cpu :-(
> >> Could you run it again? Actually 1 cpu and 4 cpus are probably enough.
> >>     
> >
> > Sure.  (ran as before, hopefully no transcription errors)
> >
> >   
> Thanks:
> sysv sem:
> - 2.6.22 had almost linear scaling (up to 4 cores).
> - 2.6.24.3 scales to 2 cpus, then it collapses. with 4 cores, it's 75% 
> slower than 2.6.22.
> 
> sysv msg:
> - neither 2.6.22 nor 2.6.24 scale very good. That's more or less 
> expected, the message queue code contains a few global statistic 
> counters (msg_hdrs, msg_bytes).

Actually, 2.6.22 is fine, and 2.6.24.3 is not, just as sysv sem.  I just
noticed that pmsg didn't get recompiled last night (fat finger) , and
sent a correction. 
 
	-Mike

