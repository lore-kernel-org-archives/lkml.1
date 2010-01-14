Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953Ab0ANGIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0ANGIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382Ab0ANGIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:08:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab0ANGIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:08:47 -0500
Date: Wed, 13 Jan 2010 22:07:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, mingo@elte.hu,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] timers: Introduce the concept of timer slack for legacy
 timers
Message-Id: <20100113220755.7ad6286f.akpm@linux-foundation.org>
In-Reply-To: <20100113214528.41e2de4a@infradead.org>
References: <20100109133744.29829988@infradead.org>
	<20100113135219.f7e8a2f9.akpm@linux-foundation.org>
	<20100113214528.41e2de4a@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 21:45:28 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> On Wed, 13 Jan 2010 13:52:19 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I suppose this could be inlined.
> 
> .. and then I expand it a bit in a few weeks and guess who complains an
> inline gets too big ? ;-)
> 

Me!

You're proposing that we include trivially-fixed overhead to every
Linux machine in the world to save ourselves 15 minutes effort?  Nope,
bad tradeoff.

> > 
> > But the set_timer_slack() interface has no callers.  Perhaps it
> > should?
> 
> I have some callers pending, and I thought I posted those to lkml but
> maybe I did not.

hm.

Have you any feeling for how much power this sort of thing saves?  I
guess "change in interrupts per minute" would be easy to measure.
