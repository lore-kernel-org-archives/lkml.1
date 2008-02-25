Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbYBYWVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbYBYWVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYBYWVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:21:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57570 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758828AbYBYWVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:21:23 -0500
Date: Mon, 25 Feb 2008 23:21:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080225222147.GM2659@elf.ucw.cz>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com> <20080225114611.d91791f6.akpm@linux-foundation.org> <8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com> <200802252157.10412.rjw@sisk.pl> <20080225212615.GA2659@elf.ucw.cz> <47C333F6.40501@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C333F6.40501@garzik.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-25 16:32:38, Jeff Garzik wrote:
> Pavel Machek wrote:
>>> commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
>>> Author: Pavel Machek <pavel@ucw.cz>
>>> Date:   Thu Feb 21 13:56:55 2008 +0100
>>>
>>>     power_state: get rid of write-only variable in SATA
>>
>> This is pretty unlikely to be it. Can you double check that this patch
>> really breaks something?
>
> Quote...
>
> 	After reverting 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
> 	on top of 2.6.25-rc3 the kernel again resumes from suspend to
> 	ram.
>
> Seems pretty clear to me.

Yep, that patch was crappy. I developed it on machine with SCSI
powersave patches applied, and did not realize this code
changed. Sorry.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
