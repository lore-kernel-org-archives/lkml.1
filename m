Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbXCRV5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbXCRV5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbXCRV5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:57:48 -0400
Received: from www.osadl.org ([213.239.205.134]:34423 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933295AbXCRV5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:57:47 -0400
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Bauer <JohannesBauer@gmx.de>, linux-kernel@vger.kernel.org,
       schwab@suse.de, Stable Kernel Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <45FDB4C9.5030103@redhat.com>
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com>
	 <1173817985.13341.120.camel@localhost.localdomain>
	 <1173866413.13341.154.camel@localhost.localdomain>
	 <20070316124313.9f0afc05.akpm@linux-foundation.org>
	 <1174079120.13341.286.camel@localhost.localdomain>
	 <45FDAC3B.6000202@redhat.com>
	 <1174253579.13341.477.camel@localhost.localdomain>
	 <45FDB4C9.5030103@redhat.com>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 23:04:47 +0100
Message-Id: <1174255487.13341.480.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 17:53 -0400, Chuck Ebbert wrote:
> >> Just to be clear: this replaces the earlier patch, right?
> > 
> > This replaces the fix Andrew did.
> > 
> > http://marc.info/?l=linux-kernel&m=117407812411997&w=2
> > 
> 
> Right, but is the original "Prevent DOS" patch from you still needed?
> Or did Andrew's patch replace that one, and now this replaces his?

The original patch is still needed - it handles the problem in the first
place.

I missed to compile it for 32bit and Andrew did a fix, which I replaced.

	tglx


