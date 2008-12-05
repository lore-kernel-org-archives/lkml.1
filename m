Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYLEMdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYLEMdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYLEMd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:33:26 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:41536 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757803AbYLEMdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:33:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoEAKuoOElMROB9/2dsb2JhbACBbc0wgwU
Date: Fri, 5 Dec 2008 07:28:22 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: prasad@linux.vnet.ibm.com, jan.kiszka@web.de,
       Gian Lorenzo Meocci <glmeocci@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, mbligh@google.com
Subject: Re: [ltt-dev] trace a futex
Message-ID: <20081205122822.GA25816@Krystal>
References: <8d94e9280812021142j2eb5ca72td730410e97ccd9a1@mail.gmail.com> <20081202195015.GA25792@Krystal> <8d94e9280812021215m6a63d6c2l4e64acd26274953d@mail.gmail.com> <20081202215519.GA734@Krystal> <4935B25F.7010701@web.de> <20081203052640.GA13701@Krystal> <20081203180131.GA2904@in.ibm.com> <1228380784.5092.18.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1228380784.5092.18.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:23:54 up 18 days, 13:04,  3 users,  load average: 1.24, 1.07,
	0.76
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> 
> FWIW, the ftrace infrastructure has on many an occasion (even before it
> was called ftrace and specific to -rt) helped in debugging and fixing
> futex races.
> 

Hrm, I'm not sure futex races is the key aspect of interest here.
Knowing which amount of pthread mutex lock calls ends up calling the
scheduler looks a bit more like the topic brought by this particular
use-case. Therefore, correlating the information from the nptl with the
kernel information would be useful.

Is lockdep called when a futex is taken ? Should we add instrumentation
(tracepoints) to futex.c ? If yes, was there specific instrumentation
you used with ftrace that should be added ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
