Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbZFBNms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbZFBNms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZFBNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:42:42 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:49969 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZFBNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:42:41 -0400
Subject: Re: [RFC PATCH 1/1] smi_detector: A System Management Interrupt
 detector
From: Jon Masters <jonathan@jonmasters.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rostedt@goodmis.org
In-Reply-To: <20090602075450.GA12411@elte.hu>
References: <20090531163117.502167374@jonmasters.org>
	 <20090531163343.771922592@jonmasters.org>
	 <20090601205720.825d3048.akpm@linux-foundation.org>
	 <20090602075450.GA12411@elte.hu>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 02 Jun 2009 09:41:50 -0400
Message-Id: <1243950111.31439.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 09:54 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 31 May 2009 12:31:18 -0400 Jon Masters <jonathan@jonmasters.org> wrote:
> > 
> > > This patch introduces a new SMI (System Management Interrupt) detector module
> > > that can be used to detect high latencies within the system. It was originally
> > > written for use in the RT kernel, but has wider applications.
> > > 
> > 
> > Neat-looking code.
> > 
> > AFACIT it can be used on any platform.  Suppose that powerpcs or ia64s
> > also mysteriously go to lunch like PC's do - I think the code will work
> > for them too?  In which case the "smi" name is excessively specific. 
> > Not a big deal though.

Yeah, you're right.

> Yes, i wondered about that too - this is really a generic method 
> that detects and measures hardware latencies.

Indeed. I guess SMIs were the main example, but sure they're not the
only one around. So I'll rename it to hwlat or something, clean it up
according to Andrew's comments, and repost later.

Jon.


