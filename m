Return-Path: <linux-kernel-owner+w=401wt.eu-S1423042AbXEANpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423042AbXEANpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbXEANpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:45:54 -0400
Received: from www.osadl.org ([213.239.205.134]:44319 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753106AbXEANpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:45:53 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with
	either/both	of	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mark Lord <lkml@rtr.ca>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <463741F1.7050706@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca>
	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>
	 <463741F1.7050706@rtr.ca>
Content-Type: text/plain
Date: Tue, 01 May 2007 15:48:05 +0200
Message-Id: <1178027285.5791.307.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 09:34 -0400, Mark Lord wrote:
> > now at 3232363876949 nsecs
> ...
> 
> Oh, in case it matters any:
> that /proc/timer_list is from the system with CFS-V7 also patched in.

It should not. What happens when you disable HPET ?

	tglx


