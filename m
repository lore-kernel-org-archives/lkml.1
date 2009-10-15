Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbZJOADH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbZJOADH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZJOADG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:03:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41393 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZJOADE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:03:04 -0400
Date: Wed, 14 Oct 2009 17:02:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>, Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Re: Userspace RCU 0.2.3
Message-ID: <20091015000225.GG6763@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091014223657.GC6458@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014223657.GC6458@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 06:36:57PM -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> I just released lib urcu 0.2.3, which is now using autotools. I also
> integrated automatic architecture detection for old 386 which lack
> cmpxchg (using a fall-back if necessary). I also use a lock; addl
> instead of mfence on x86-32 to support a larger variety of older Intel
> CPUs.

!!!

Is there anyone on these lists other than me who has actually used an
SMP 80386-based system?

Either way, much appreciated for old time's sake.  The things we used
to do to avoid the need for cmpxchg!  ;-)

							Thanx, Paul

> The build system detects if NR_futex is available in the system
> headers. It falls back on a more portable alternative if they are not
> available.
> 
> There are also new configuration modes to ./configure for UP-only
> systems.
> 
> As always, the tarballs are available at http://www.lttng.org/urcu
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
