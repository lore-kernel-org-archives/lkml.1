Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928AbXBKXK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbXBKXK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXBKXK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:10:29 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:39127 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXBKXK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:10:28 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070211210258.0b8da53c@localhost.localdomain>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl>
	 <20070211194202.GC15445@elf.ucw.cz>
	 <20070211210258.0b8da53c@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:10:28 +1100
Message-Id: <1171235428.4493.105.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-02-11 at 21:02 +0000, Alan wrote:
> > > "If the device requires that, implement .suspend and .resume or at least
> > > define .suspend that will always return -ENOSYS (then people will know they
> > > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > > whether or not the device requires .suspend and .resume, define .suspend that
> > > will always return -ENOSYS."
> > 
> > Sounds ok to me. Where should this text go?
> > Documentation/SubmittingDrivers ?
> 
> And testing/submitting drivers, perhaps with additional text in that to
> make it clear we want suspend/resume support or good excuses
> 
> "Please verify your driver correctly handles suspend and resume. If it
> does not your patch submission is likely to be suspended and only resume
> when the driver correctly handles this feature"

Maybe make it explicit that testing should be done for both suspend to
ram and to disk, and with the following usage scenarios as applicable?

- built in;
- modular, loaded while suspending but not loaded prior to resume from
disk;
- modular, loaded while suspending and loaded prior to resume from disk;

Regards,

Nigel

