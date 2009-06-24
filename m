Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZFXAqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZFXAqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZFXAqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:46:06 -0400
Received: from wynq.bellnexxia.net ([209.226.175.27]:38496 "EHLO
	toq5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZFXAqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:46:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEADUQQUpMQWRX/2dsb2JhbACBUZg6t2CECgWBNA
Date: Tue, 23 Jun 2009 20:43:56 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Tom Zanussi <tzanussi@gmail.com>, karim@opersys.com,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Lai Jiangshan <laijs@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Dual-licensing LTTng, marker and tracepoints under GPLv2+/LGPLv2.1+
Message-ID: <20090624004356.GB28911@Krystal>
References: <4A412702.80707@polymtl.ca> <20090623191128.GA19010@Krystal> <20090623191513.GA20253@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090623191513.GA20253@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:29:26 up 115 days, 20:55,  5 users,  load average: 0.91, 0.68,
	0.50
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We want to re-license LTTng as

  dual-license GPLv2 (or better)/LGPLv2.1 (or better)

to facilitate code exchange between the GPLv2 LTTng kernel tracer and
LGPLv2.1 userspace LTTng tracing library.  This will also include
kernel/marker.c, include/linux/marker.h, kernel/tracepoint.c and
include/linux/tracepoint.h. For the LTTng tree, everything under the
ltt/ subdirectory is targeted.

I am the main author of most of these files, and I allow such license
change as far as my code is concerned. Additionally, we need the
approval of most people who contributed code to either LTTng, Linux
Kernel Marker and Tracepoints.

Some in ltt/ltt-relay-alloc.c and include/linux/ltt-relay.h is derived
from kernel/relay.c, on which IBM owns the copyright. I would appreciate
if Paul or Bob could have a look into this.

Hopefully with lkml and ltt-dev, I am reaching most people concerned.

Thanks,

Mathieu


* Pierre-Marc Fournier (pierre-marc.fournier@polymtl.ca) wrote:
> Hello Tom and Karim,
>
> I am writing to you because you are mentioned as copyright holders in  
> LTTng files:
>
> ltt-relay-alloc.c
> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=ltt/ltt-relay-alloc.c;h=d073163a75e1f85a9833741b4bce58f8ad27b3e5;hb=2.6.30-lttng-0.141
>
> ltt-relay.h
> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=include/linux/ltt-relay.h;h=a8c8836d5a86fd18ca3903f803b08a3672ba1ea9;hb=2.6.30-lttng-0.141
>
>
> At Polytechnique, we are making a userspace port of LTTng. In order for  
> this port to be available to as many users as possible, we would need to  
> license it under LGPL 2.1. Therefore, would you give your permission to  
> release the userspace port of the above files under LGPL 2.1?
>
> Userspace port of the files (please do not distribute as this is not yet  
> released):
>
> relay.c
> http://git.dorsal.polymtl.ca/?p=ust.git;a=blob;f=libust/relay.c;h=27794f9e5e2070358d2658b1ab0fa86336d56fc9;hb=c39c72ee5890c7727ae2697f321ba1b3d6c862f5
>
> relay.h
> http://git.dorsal.polymtl.ca/?p=ust.git;a=blob;f=libust/relay.h;h=ba7c1d63aa2d10c35349bf2d86b70e9000228e04;hb=c39c72ee5890c7727ae2697f321ba1b3d6c862f5
>
>
> Another question: would you allow us to license the two first files  
> (ltt-relay-alloc.c and ltt-relay.h) from the kernel tracer as LGPL? This  
>  would ease maintenance, as it would allow to port code from the kernel  
> tracer to the userspace tracer.

Just to make this clearer : We plan to switch to a dual-license scheme
for LTTng (GPLv2 + LGPLv2.1) to facilitate further resynchronization
between the kernel LTTng and userspace library LTTng.

Thanks,

Mathieu

>
> Thanks
>
> pmf


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
