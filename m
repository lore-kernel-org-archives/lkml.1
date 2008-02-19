Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYBSIQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYBSIQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYBSIP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:15:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:53426 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750920AbYBSIP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:15:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18kdZBMSzIkzbjpaVlLkyHc8N3sry+8OYCM4WnwAw
	mgA+nV325+K8zt
Subject: Re: 2.6.24-git4+ regression
From: Mike Galbraith <efault@gmx.de>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1203345102.5984.1.camel@homer.simson.net>
References: <20080130135609.GA5100@ics.muni.cz>
	 <20080214165551.GA21963@linux.vnet.ibm.com>
	 <20080217202642.GA4327@ics.muni.cz> <20080218042831.GJ30201@elte.hu>
	 <1203320304.26269.3.camel@homer.simson.net>
	 <20080218082021.GD14419@linux.vnet.ibm.com>
	 <1203323815.5443.4.camel@homer.simson.net>
	 <1203325554.4889.2.camel@homer.simson.net>
	 <1203345102.5984.1.camel@homer.simson.net>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 09:15:56 +0100
Message-Id: <1203408956.15607.20.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, I notice that I poked reply.   Doesn't matter, but for interested
readers...

On Mon, 2008-02-18 at 15:31 +0100, Mike Galbraith wrote:

> > > I'll try this patch later (errands).
> > 
> > This is sched-devel with your first patch still applied.  Much evilness.
> > At first, I had much idle time, then it settled into this.
> > 
> > I'll revert your first patch and test this one alone after errands.
> > 
> > top - 10:02:34 up 4 min, 15 users,  load average: 5.09, 3.35, 1.46
> > Tasks: 220 total,   6 running, 214 sleeping,   0 stopped,   0 zombie
> > Cpu0  : 35.3%us, 64.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> > Cpu1  : 35.0%us, 65.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
> >  5337 root      20   0  1464  360  304 R  101  0.0   1:12.16 1 chew-max
> >  5355 mikeg     20   0  1464  364  304 R   53  0.0   1:13.51 0 chew-max
> >  5341 root      20   0  1464  364  304 R   22  0.0   0:33.05 0 chew-max
> >  5352 root      20   0  1464  364  304 R   22  0.0   0:47.08 0 chew-max
> 
> Everyone moved onto CPU 1, and stuck.
> 
> top - 15:28:31 up 2 min, 15 users,  load average: 4.03, 2.10, 0.83
> Tasks: 212 total,   6 running, 206 sleeping,   0 stopped,   0 zombie
> Cpu0  :  4.0%us,  3.0%sy,  0.0%ni, 93.1%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu1  : 41.2%us, 58.8%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  5419 mikeg     20   0  1464  364  304 R   33  0.0   0:14.71 1 chew-max
>  5401 root      20   0  1464  364  304 R   23  0.0   0:11.74 1 chew-max
>  5412 root      20   0  1464  364  304 R   23  0.0   0:08.93 1 chew-max
>  5402 root      20   0  1464  360  304 R   22  0.0   0:10.44 1 chew-max

