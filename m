Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYKGKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYKGKmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYKGKmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:42:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60034 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYKGKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:42:43 -0500
Date: Fri, 7 Nov 2008 11:44:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.28-rc2-mm1: multiple BUG: scheduling while atomic:
	swapper, first in acpi_idle_enter_simple, then fbcon has problems
Message-ID: <20081107104420.GB2146@elf.ucw.cz>
References: <20081106102309.GA334@atrey.karlin.mff.cuni.cz> <20081106093324.57d88a43.akpm@linux-foundation.org> <alpine.LFD.2.00.0811061354340.3106@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811061354340.3106@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-06 13:56:16, Len Brown wrote:
> 
> 
> > > ...kernel contains experimental version of HP accelerometer driver and
> > > new HP acclerometer LED, but hopefully they are not causing this?
> > > 
> > 
> > The trace is a bit of a mess, but we first hit problems around
> > acpi_idle(), so I'd be suspecting acpi, x86 or sched-type changes.
> 
> try "idle=poll" to run none of the ACPI idle code.
> or "idle=halt" to just flirt with the idle code.

I'll try that if the problem happens. I had problems twice on two
boots, but then it started to behave, so...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
