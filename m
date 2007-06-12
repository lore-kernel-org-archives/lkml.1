Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbXFMNiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbXFMNiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbXFMNhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:37:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2818 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753470AbXFMNhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:37:48 -0400
Date: Tue, 12 Jun 2007 15:31:03 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Message-ID: <20070612153102.GD5986@ucw.cz>
References: <878xb35sje.fsf@goat.bogus.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878xb35sje.fsf@goat.bogus.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> resume from suspend to ram doesn't work for my laptop and never
> has. So, this is not a regression.
> 
> Hibernate (aka suspend to disk) works, however.
> 
> When I resume, everything seems to come up (fan becomes busy, disk and
> dvd spin up for a short time), but the machine is not responding to
> anything - neither keyboard, mouse nor ping from another machine. The
> laptop is effectively dead and only a power cycle helps.
> 
> I've tried a minimal config and init=/bin/bash as well, but the result
> is the same.

Beeping patch? It is in -mm now. noapic nolapic and nosmp are useful,
too.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
