Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbXBWKJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbXBWKJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:09:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXBWKJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:09:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60054 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbXBWKJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:09:01 -0500
Date: Fri, 23 Feb 2007 02:08:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: dwalker@mvista.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Linux 2.6.21-rc1
Message-Id: <20070223020829.40e5fac3.akpm@linux-foundation.org>
In-Reply-To: <1172079671.25076.80.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	<1172075053.8577.38.camel@imap.mvista.com>
	<1172077664.25076.75.camel@localhost.localdomain>
	<1172078340.8577.43.camel@imap.mvista.com>
	<1172079671.25076.80.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 21 Feb 2007 18:41:11 +0100 Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 2007-02-21 at 09:19 -0800, Daniel Walker wrote:
> > > At this point the PIT / HPET _is_ active and incrementing jiffies. The
> > > switch to local apic timers happens afterwards. 
> > 
> > Could be the switch over then which confuses the NMI . 
> 
> Why? The switch just stops the PIT/HPET. It does not fiddle with IO_APIC
> and friends at all.
> 
> > ftp://source.mvista.com/pub/dwalker/tglx/
> 
> Nothing obvious. Bisect time :(
> 

I already bisected this on my old pIII, which has the same problem:
clockevents-i386-drivers.patch
