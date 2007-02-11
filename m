Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbXBKUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbXBKUuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932558AbXBKUuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:50:39 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39530 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932123AbXBKUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:50:32 -0500
Date: Sun, 11 Feb 2007 21:02:58 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211210258.0b8da53c@localhost.localdomain>
In-Reply-To: <20070211194202.GC15445@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	<1171059433.8675.195.camel@laptopd505.fenrus.org>
	<20070210193851.GA3956@ucw.cz>
	<200702102320.39531.rjw@sisk.pl>
	<20070211194202.GC15445@elf.ucw.cz>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > "If the device requires that, implement .suspend and .resume or at least
> > define .suspend that will always return -ENOSYS (then people will know they
> > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > whether or not the device requires .suspend and .resume, define .suspend that
> > will always return -ENOSYS."
> 
> Sounds ok to me. Where should this text go?
> Documentation/SubmittingDrivers ?

And testing/submitting drivers, perhaps with additional text in that to
make it clear we want suspend/resume support or good excuses

"Please verify your driver correctly handles suspend and resume. If it
does not your patch submission is likely to be suspended and only resume
when the driver correctly handles this feature"


