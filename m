Return-Path: <linux-kernel-owner+w=401wt.eu-S964795AbXA2W5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795AbXA2W5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933015AbXA2W5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:57:06 -0500
Received: from www.osadl.org ([213.239.205.134]:49406 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932814AbXA2W5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:57:03 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <1170111056.21603.30.camel@funkylaptop>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <1170110318.21603.25.camel@funkylaptop>
	 <1170110732.29240.59.camel@localhost.localdomain>
	 <1170111056.21603.30.camel@funkylaptop>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jan 2007 23:57:44 +0100
Message-Id: <1170111464.29240.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 23:50 +0100, Frédéric Riss wrote:
> > That's probably a userspace problem. Are you using DHCP ?
> 
> Yep DHCP. Is that a known issue? I never had to reconfigure with older
> kernels.

Is dhclient running after resume ? What's the output of ifconfig (before
you do ifdown/up) ? Have you checked the syslog ?

	tglx


