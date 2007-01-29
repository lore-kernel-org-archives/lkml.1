Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbXA2Wo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbXA2Wo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932827AbXA2Wo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:44:56 -0500
Received: from www.osadl.org ([213.239.205.134]:40013 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964795AbXA2Woz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:44:55 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <1170110318.21603.25.camel@funkylaptop>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <1170110318.21603.25.camel@funkylaptop>
Content-Type: text/plain; charset=utf-8
Date: Mon, 29 Jan 2007 23:45:32 +0100
Message-Id: <1170110732.29240.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 23:38 +0100, Frédéric Riss wrote:
> I see the same symptoms on my Intel Mac Mini, and reverting the commit
> also allows the driver to seemingly resume correctly. 
> 
> However after coming out of sleep I need to reconfigure the network
> interface. No need to rmmod/insmod, just ifdown/ifup is sufficient (but
> of course shouldn't be necessary, should it?). If I don't reconfigure
> it, ping from/to the box will work, but nothing more complicated like
> ssh will go through.

That's probably a userspace problem. Are you using DHCP ?

	tglx


	

