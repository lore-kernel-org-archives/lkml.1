Return-Path: <linux-kernel-owner+w=401wt.eu-S1422729AbXBURkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422729AbXBURkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422731AbXBURky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:40:54 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7326 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422729AbXBURky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:40:54 -0500
Subject: Re: Linux 2.6.21-rc1
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172079671.25076.80.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 09:38:43 -0800
Message-Id: <1172079523.8577.48.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 18:41 +0100, Thomas Gleixner wrote:
> On Wed, 2007-02-21 at 09:19 -0800, Daniel Walker wrote:
> > > At this point the PIT / HPET _is_ active and incrementing jiffies. The
> > > switch to local apic timers happens afterwards. 
> > 
> > Could be the switch over then which confuses the NMI . 
> 
> Why? The switch just stops the PIT/HPET. It does not fiddle with IO_APIC
> and friends at all.

I'm not an expert on the io-apic, but the check_timer() function seemed
to assume IRQ0 was happening regularly ..

> > ftp://source.mvista.com/pub/dwalker/tglx/
> 
> Nothing obvious. Bisect time :(

Well, I'm pretty sure it's HRT, cause in prior versions this only
happened when HRT is enabled. Then you guys went to the lapic all the
time, and now this is happening all the time ..

You can't reproduce this?

Daniel

