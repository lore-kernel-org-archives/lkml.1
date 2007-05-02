Return-Path: <linux-kernel-owner+w=401wt.eu-S2992770AbXEBGPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992770AbXEBGPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992789AbXEBGPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:15:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992770AbXEBGPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:15:10 -0400
Date: Tue, 1 May 2007 23:14:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [patch 0/3] Clocksource / clockevent updates
Message-Id: <20070501231452.fc706552.akpm@linux-foundation.org>
In-Reply-To: <1178086170.5791.338.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	<20070501173356.15e9d482.akpm@linux-foundation.org>
	<1178086170.5791.338.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 08:09:29 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2007-05-01 at 17:33 -0700, Andrew Morton wrote:
> > On Mon, 30 Apr 2007 10:43:31 -0000
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > Andrew,
> > > 
> > > please pick up the following updates to clocksource / clockevents:
> > > 
> > > - Fixups to the resume logic
> > > - Keep TSC stable, when lapic_timer_c2_ok is set
> > > 
> > 
> > Should we be targetting these at 2.6.20.x?
> 
> 2.6.21.x ?
> 
> Hmm. They should get some testing first, but otherwise yes.
> 

OK, I added the cc.  The second patch won't apply to 2.6.21 when we get
around to it, but it'll be pretty simple to repair.
