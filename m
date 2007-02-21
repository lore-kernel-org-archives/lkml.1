Return-Path: <linux-kernel-owner+w=401wt.eu-S1422728AbXBURgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422728AbXBURgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422732AbXBURgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:36:08 -0500
Received: from www.osadl.org ([213.239.205.134]:38420 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422728AbXBURgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:36:07 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172078340.8577.43.camel@imap.mvista.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 18:41:11 +0100
Message-Id: <1172079671.25076.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 09:19 -0800, Daniel Walker wrote:
> > At this point the PIT / HPET _is_ active and incrementing jiffies. The
> > switch to local apic timers happens afterwards. 
> 
> Could be the switch over then which confuses the NMI . 

Why? The switch just stops the PIT/HPET. It does not fiddle with IO_APIC
and friends at all.

> ftp://source.mvista.com/pub/dwalker/tglx/

Nothing obvious. Bisect time :(

	tglx


