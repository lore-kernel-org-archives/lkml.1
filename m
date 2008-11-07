Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYKGQMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYKGQMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYKGQMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:12:41 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:34818 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbYKGQMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:12:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAK/2E0lMQWxa/2dsb2JhbACBdsgDg1Y
Date: Fri, 7 Nov 2008 11:12:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 07/18] Trace clock core
Message-ID: <20081107161237.GA22134@Krystal>
References: <20081107052336.652868737@polymtl.ca> <20081107053349.699011457@polymtl.ca> <20081106215256.a9f01ec4.akpm@linux-foundation.org> <20081107061643.GA798@Krystal> <20081106222656.8e35d9d5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081106222656.8e35d9d5.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:12:21 up 155 days, 20:52,  6 users,  load average: 0.61, 0.67,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 7 Nov 2008 01:16:43 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > Is there something we should be fixing in m68k?
> > > 
> > 
> > Yes, but I fear it's going to go deep into include hell :-(
> 
> Oh, OK.  I thought that the comment meant that m68k's on_each_cpu()
> behaves differently at runtime from other architectures (and wrongly).
> 
> If it's just some compile-time #include snafu then that's far less
> of a concern.
> 

Should I simply remove this comment then ?


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
