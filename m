Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0BQRIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:08:19 -0500
Received: from www.tglx.de ([62.245.132.106]:44889 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab0BQRIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:08:18 -0500
Date: Wed, 17 Feb 2010 18:07:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch -tip/core/rcu] rcu: Convert to raw_spinlocks
In-Reply-To: <20100217170249.GB6959@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1002171807360.2811@localhost.localdomain>
References: <20100217162054.114542795@linutronix.de> <20100217170249.GB6959@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Paul E. McKenney wrote:

> On Wed, Feb 17, 2010 at 04:23:00PM -0000, Thomas Gleixner wrote:
> > The spinlocks in rcutree need to be real spinlocks in
> > preempt-rt. Convert them to raw_spinlocks.
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Except that it conflicts with some of my patch stack.  So I will apply
> this on top of my stack and re-send, if that is OK.

Please do. Thanks,

       tglx


