Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0BAOKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:10:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35154 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0BAOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:10:47 -0500
Date: Mon, 1 Feb 2010 15:10:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garrett <jeff@jgarrett.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100201141038.GA1340@ucw.cz>
References: <20100126084740.GA5265@jgarrett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126084740.GA5265@jgarrett.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-01-26 02:47:40, Jeff Garrett wrote:
> Hi,
> 
> I was trying to chase down a theory that my desktop machine (a core i7)
> is running warm (the fan sounds like it's at full speed all the time,
> and I think it's not always acted this way -- hence the theory).
> 
> powertop is never showing it spending any time in C3...
> 
> I compiled a kernel without USB/sound/radeon, and ran without X.  I was
> able to get the wakeups/sec down below 20, but no time is spent in C3.

> This may be a complete red herring, but I added some printk logic to
> acpi_idle_bm_check(), and it is getting called often, but bm_status is
> always 1.  [I infer from this that the idle logic is trying to go into
> C3, but this check is stopping it...  Unless I misread something.]
> 
> Is this expected behavior or is this a legitimate problem?
> 
> How might I investigate this further?

DMA keeps system awake? Possibly USB?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
