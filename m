Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZJLSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZJLSar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZJLSaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:30:46 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:61242 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757559AbZJLSap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:30:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAG8M00pMROOX/2dsb2JhbACBUtVOhC0E
Date: Mon, 12 Oct 2009 14:30:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 0/4] DEBUG_RCU_HEAD: Debug and fix racy call_rcu() users
Message-ID: <20091012183007.GA12445@Krystal>
References: <20091006143727.868480435@polymtl.ca> <20091012180739.GE17138@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091012180739.GE17138@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:26:37 up 55 days,  5:16,  3 users,  load average: 0.19, 0.34,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Here is a patchset, done on 2.6.30.9, which permits to detect and fix 
> > racy call_rcu() users.
> 
> Nice idea - but any reason why this isnt using the debugojects 
> framework? That debugging framework is upstream already and allows this 
> kind of object lifetime debugging - in a much broader way.
> 

Other than: it did not occur to me, no, there is no reason for not using
debugobjects there. :-)

As long as we can tag the object as
- initialized
- active
- inactive

And dump a nice fat warning when the object is activated twice, that
should suffice. Now time is a bit short on my side, but I'll keep in
mind to respin a version on top of debugobjects soon.

Thanks,

Mathieu


> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
