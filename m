Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXBWOs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXBWOs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbXBWOs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:48:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXBWOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:48:27 -0500
To: tglx@linutronix.de
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	<1172099859.25076.132.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Feb 2007 16:48:19 +0100
In-Reply-To: <1172099859.25076.132.camel@localhost.localdomain>
Message-ID: <p73d540dge4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
> > 
> > Interrupt 0 is stuck at 114 (the number is consistent across reboots). I
> > don't experience any problem, time is running fine. Still it's strange
> > that the timer is doing nothing; maybe something other than the PIT is
> > used for time keeping?
> 
> Yes, we switch away from PIT and use the local APIC timer. (LOC)

Before this becomes a FAQ. Would anybody mind if I just renamed "timer"
to "pit" to make this clear? 

-Andi
