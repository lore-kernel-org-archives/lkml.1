Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbXA0Wnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbXA0Wnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbXA0Wnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:43:31 -0500
Received: from www.osadl.org ([213.239.205.134]:55505 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932138AbXA0Wna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:43:30 -0500
Subject: Re: Linux 2.6.20-rc6 - suspend / resume ata_piix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <45BBD4CA.70303@garzik.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169935901.17469.159.camel@localhost.localdomain>
	 <45BBD4CA.70303@garzik.org>
Content-Type: text/plain
Date: Sat, 27 Jan 2007 23:44:02 +0100
Message-Id: <1169937843.17469.163.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-01-27 at 17:40 -0500, Jeff Garzik wrote:
> > During the second resume the ATA interrupt gets disabled due to an
> > unhandled interrupt.
> > 
> > This is 100% reproducible. So I can provide as much info as needed.
> 
> Is this a regression, or behavior that's always been present?

No, that's new. Something post 2.6.19

> If its a regression, what changeset caused the problem?

Hey. I just discovered that crap. I'm going to bisect tomorrow. Bed time
here in good old Europe. :)

	tglx


