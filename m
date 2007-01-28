Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbXA1WFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbXA1WFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932915AbXA1WFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:05:03 -0500
Received: from www.osadl.org ([213.239.205.134]:39301 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932914AbXA1WFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:05:01 -0500
Subject: Re: Linux 2.6.20-rc6 - suspend / resume ata_piix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1169937843.17469.163.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169935901.17469.159.camel@localhost.localdomain>
	 <45BBD4CA.70303@garzik.org>
	 <1169937843.17469.163.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 28 Jan 2007 23:05:36 +0100
Message-Id: <1170021936.17469.176.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-01-27 at 23:44 +0100, Thomas Gleixner wrote:
> > If its a regression, what changeset caused the problem?
> 
> Hey. I just discovered that crap. I'm going to bisect tomorrow. Bed time
> here in good old Europe. :)

It seems to be there in 2.6.18 already, although it takes more
suspend/resume cycles to show up. So it's just the surfacing of some
longer standing problem. Just went unnoticed.

	tglx


