Return-Path: <linux-kernel-owner+w=401wt.eu-S1423126AbXBUVQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423126AbXBUVQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423128AbXBUVQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:16:04 -0500
Received: from www.osadl.org ([213.239.205.134]:51609 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423126AbXBUVQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:16:01 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0702211302300.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
	 <1172082200.8577.56.camel@imap.mvista.com>
	 <1172085792.25076.119.camel@localhost.localdomain>
	 <1172088050.8577.71.camel@imap.mvista.com>
	 <1172090603.25076.127.camel@localhost.localdomain>
	 <1172090973.8577.77.camel@imap.mvista.com>
	 <Pine.LNX.4.64.0702211302300.4043@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 22:21:08 +0100
Message-Id: <1172092868.25076.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 13:06 -0800, Linus Torvalds wrote:
> That said, considering that you did get a commit that doesn't look 
> entirely unlikely (and that clearly changes things that are relevant), I 
> suspect you did actually find the right one.

Yup, thats the one which switches off PIT after we have the local APIC
timers up and running. Which turns out to cause the nmi_watchdog not
working anymore.

	tglx


