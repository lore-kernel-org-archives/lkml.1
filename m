Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYCYOnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYCYOnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYCYOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:42:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3839 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754670AbYCYOmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:42:52 -0400
Date: Tue, 25 Mar 2008 09:49:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: APM crashes when IO is going on
Message-ID: <20080325084923.GB4547@ucw.cz>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz> <200803210127.56437.rjw@sisk.pl> <Pine.LNX.4.64.0803212055550.6726@artax.karlin.mff.cuni.cz> <200803212215.54854.rjw@sisk.pl> <Pine.LNX.4.64.0803212216540.16100@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803212216540.16100@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Either the on-going I/O will jam BIOS and I need to remove power to 
> > > continue.
> > > 
> > > Or the machine suspends, wakes up and reports "hda: lost interrupt" 
> > > (2.6.23.1 was able to recover from this condition, 2.6.25rc3,6 does not 
> > > recover and it is not able to send any more disk IOs).
> > > 
> > > How is suspending disk IO supposed to work?

Suspending IO is not supposed to be needed in APM case, try ACPI.

(We could work around this.. You should be able to reuse
kernel/power/main.c to stop all user processes, then stop the
drivers...)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
