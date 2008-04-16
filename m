Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbYDPXdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbYDPXdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYDPXdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:33:33 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:33104 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbYDPXdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:33:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EABIpBkhMROPA/2dsb2JhbACBYKwq
Date: Wed, 16 Apr 2008 19:33:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC patch 23/27] Immediate Values - Powerpc Optimization NMI
	MCE support
Message-ID: <20080416233331.GA9225@Krystal>
References: <20080416213426.298498397@polymtl.ca> <20080416213556.704299869@polymtl.ca> <18438.34621.508450.720068@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <18438.34621.508450.720068@cargo.ozlabs.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:31:36 up 47 days, 19:42,  5 users,  load average: 0.05, 0.09,
	0.13
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras (paulus@samba.org) wrote:
> Mathieu Desnoyers writes:
> 
> > Use an atomic update for immediate values.
> 
> What is meant by an "atomic" update in this context?  AFAICS you are
> using memcpy, which is not in any way guaranteed to be atomic.
> 
> Paul.

I expect memcpy to perform the copy in one memory access, given I put a 

  .align 2

before the 2 bytes instruction. It makes sure the instruction modified
fits in a single, aligned, memory write.

Or maybe am I expecting too much from memcpy ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
