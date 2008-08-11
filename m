Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYHKTfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYHKTfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYHKTfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:35:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52624 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYHKTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:35:17 -0400
Date: Mon, 11 Aug 2008 12:27:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH diagnostic] Re: HPET regression in 2.6.26 versus 2.6.25
	-- RCU problem
Message-ID: <20080811192740.GM6762@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <173065.89301.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173065.89301.qm@web82104.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 11:22:21AM -0700, David Witbrodt wrote:
> 
> 
> > > Well, I was hoping to see something interesting.  I ran it with parameters
> > > "debug initcall_debug", and it locked up at the same place.  I let it for
> > > 15 minutes, in case of some delayed reaction.  Nada.
> > 
> > Interesting.  The causes could be:
> > 
> > o    Scheduling-clock interrupts aren't happening, as Ingo suggested.
> 
> Does anyone have a short answer to this question:  Were the changes between
> 2.6.25 and 2.6.26 so major that interrupts are NOW being used that were not
> being used before?

Not that I am aware of, but I must defer to others who know more about
Linux's timer interrupts than do I.

							Thanx, Paul

> Again, I don't even pretend to understand the kernel's inner workings, but
> 2.6.25 _did_ work on this hardware... and with HPET enabled.
> 
> 
> DW
