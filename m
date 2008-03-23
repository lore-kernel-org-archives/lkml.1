Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYCWHVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYCWHVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 03:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYCWHUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 03:20:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:40897 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752884AbYCWHUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 03:20:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+5+kNtWci5wkv+hxwIfqMd3UkpGSHf52BHNIRxWV
	7oXDsm/eTjpo/D
Subject: Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1206256081.3649.13.camel@marge.simson.net>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
	 <1206186832.4545.1.camel@marge.simson.net>
	 <47E51637.8060102@colorfullife.com>
	 <1206214504.4538.8.camel@marge.simson.net>
	 <1206256081.3649.13.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 08:20:50 +0100
Message-Id: <1206256850.4367.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-03-23 at 08:08 +0100, Mike Galbraith wrote:
> On Sat, 2008-03-22 at 20:35 +0100, Mike Galbraith wrote:
> > On Sat, 2008-03-22 at 15:22 +0100, Manfred Spraul wrote:
> > > Mike Galbraith wrote:
> > > > Total: 4691827                                Total: 3942000
> > > >   
> > > Thanks. Unfortunately the test was buggy, it bound the tasks to the 
> > > wrong cpu :-(
> > > Could you run it again? Actually 1 cpu and 4 cpus are probably enough.
> > 
> > Sure.  (ran as before, hopefully no transcription errors)
> 
> Looking at the output over morning java, I noticed that pmsg didn't get
> recompiled due to a fat finger, so those numbers are bogus.  Corrected
> condensed version of output is below, charted data attached.
> 
> (hope evolution doesn't turn this into something other than plain text)

Pff, I'd rather have had the bounce.  Good thing I attached the damn
chart, evolution can't screw that up.

> 
> 
> 
>              1
>              2
>              3
>              4
> 2.6.22.18-cfs-v24.1 psem
>        4791557
>        9403536
>       13583603
>       18103350
> 2.6.22.18-cfs-v24.1 pmsg
>        4906249
>        9171440
>       13264752
>       17774106
> 2.6.24.3 psem
>        4009069
>        7578648
>        8044041
>        5134381
> 2.6.24.3 pmsg
>        3917588
>        7290206
>        7644794
>        4824967
> 

