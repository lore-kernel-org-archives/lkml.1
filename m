Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZCQTft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZCQTft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZCQTfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:35:40 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:54870 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752924AbZCQTfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:35:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0FABuTv0lMQW1W/2dsb2JhbACBTtMag3wG
Date: Tue, 17 Mar 2009 15:35:32 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: David Miller <davem@davemloft.net>
Cc: ltt-dev@lists.casi.polymtl.ca, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       jwboyer@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090317193532.GA18503@Krystal>
References: <20090317013220.GA22474@Krystal> <20090317050135.GB6859@linux.vnet.ibm.com> <20090317160635.GE10092@Krystal> <20090317.122816.246078801.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090317.122816.246078801.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:31:57 up 17 days, 15:58,  1 user,  load average: 0.27, 0.43,
	0.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Tue, 17 Mar 2009 12:06:35 -0400
> 
> > But powerpc has non-maskable interrupts, so for less than 4 cycles, I
> > think it's better to stay with the local_t variant to be NMI-safe.
> 
> Sparc64 has non-maskable interrupts too btw.
> 

OK, this alone is a strong argument to favor NMI-safe lockless algorithm
even if it is a bit slower. We should see what kind of performance
impact it has on overall tracing performance to find out if it will make
a measurable difference anyway.

Mathieu

> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
