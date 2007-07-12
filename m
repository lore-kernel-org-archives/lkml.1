Return-Path: <linux-kernel-owner+w=401wt.eu-S937447AbXGLAeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937447AbXGLAeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965167AbXGLAaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:30:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60216 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964952AbXGLAaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:30:16 -0400
Date: Wed, 11 Jul 2007 17:30:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       linux-rt-users@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -rt WIP] NMI-safe lightweight parallel-update -rt RCU
Message-ID: <20070712003011.GF14550@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070712000157.GA4168@linux.vnet.ibm.com> <20070712000937.GA1946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712000937.GA1946@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 02:09:37AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello!
> > 
> > Just work in progress, not recommended for inclusion.  Seems stable 
> > under rigorous rcutorture testing, so should be OK for 
> > experimentation.
> 
> nice stuff!
> 
> i'm wondering, could you try to do this as a splitup against -mm? I 
> think we should get people exposed to the idea of RCU_PREEMPT in the 
> upstream kernel a bit more. The netfilter folks promised some 
> preparatory enhancements to make it easier, a few months ago :)

Good point!

Besides, I might as well test out my assertion that I have made
integration with CPU hotplug easier, being as that was one of the reasons
that it got kicked out earlier this year, IIRC.  ;-)

						Thanx, Paul
