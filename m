Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZKLXC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZKLXC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZKLXCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:02:52 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:45893 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbZKLXCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:02:51 -0500
Date: Thu, 12 Nov 2009 13:14:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
	2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Message-ID: <20091112121455.GA1394@ucw.cz>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911010936.10409.rjw@sisk.pl> <alpine.LFD.2.01.0911010914100.31845@localhost.localdomain> <200911021439.28266.rjw@sisk.pl> <1257200523.7907.53.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257200523.7907.53.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> (Bug was simple but took a while to track down: machine was left in
> storage for a while, battery ran out, RTC went back to Jan 1, 1904,
> which means a negative xtime, and the new timekeeping code will do
> horrible things including hanging at resume when that happens. Fix is to
> make powerpc read_persistent_clock() to ignore the RTC when it contains
> a date older than epoch).

Additionaly, it would be nice if the machine would not hang, no matter
what RTC says...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
