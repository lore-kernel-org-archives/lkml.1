Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbXA0Rb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbXA0Rb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXA0Rb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:31:29 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:53759 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbXA0Rb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:31:28 -0500
Date: Sat, 27 Jan 2007 12:31:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 00/09] atomic.h : standardizing atomic primitives
Message-ID: <20070127173124.GA25282@Krystal>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca> <20070127021834.e26e955d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070127021834.e26e955d.akpm@osdl.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 12:30:00 up 157 days, 14:37,  2 users,  load average: 0.24, 0.43, 0.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@osdl.org) wrote:
> On Thu, 25 Jan 2007 11:15:45 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > It mainly adds support for missing 64 bits cmpxchg and 64 bits atomic add
> > unless. Therefore, principally 64 bits architectures are targeted by these
> > patches. It also adds the complete list of atomic operations on the atomic_long
> > type.
> 
> OK, I fixed eight separate compile errors in this patch series and
> now powerpc is being very ugly with a twisty maze of include dependencies.
> 
> I'm giving up.  Someone should publish a suite of cross-compilers for us
> so stuff like this doesn't need to happen.

Hi Andrew,

This seems to be caused by the fact that I use inline functions for
atomic_long_cmpxchg and atomic_long_xchg. I could simply use macros and
this problem would fade away.

I agree about the cross-compiler suite, it would be very useful here.

Mathieu

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
