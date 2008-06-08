Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYFKKCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYFKKCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYFKKCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:02:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1490 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751277AbYFKKCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:02:38 -0400
Date: Sun, 8 Jun 2008 16:21:06 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI: EC: GPE storm detected, disabling EC GPE
Message-ID: <20080608142106.GD4739@ucw.cz>
References: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com> <20080606235526.783acc83.akpm@linux-foundation.org> <dd18b0c30806070847t63b8dbc0x8bfcbafc359f7031@mail.gmail.com> <484AE148.6000204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484AE148.6000204@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sat 2008-06-07 23:28:08, Alexey Starikovskiy wrote:
> Justin Mattock wrote:
> >On Sat, Jun 7, 2008 at 6:55 AM, Andrew Morton 

> >This issue just recently started, 2.6.25-rc9 and below 
> >don't give me
> >this message.
> >
> Yes, the problem which we are fighting here is that 
> almost all Acer notebooks come with
> broken EC. It sends interrupts not regarding the fact 
> that we already ACKed it.
> It comes unnoticed on almost all machines (some notice 
> laggy keyboard, because it's the same controller after 
> all and it's busy with sending ACPI interrupts and then 
> providing same status byte over and over), but on some 
> machines keystrokes become missing, which is not 
> tolerable (#9998).

But the acer workaround breaks other machines, right?

So what about

a) use dmi blacklist for acers?

or

b) if EC storm is detected print message telling 'please pass
ec_polled=true if you experience keyboard problems', but do nothing
else?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
