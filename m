Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbYAOWQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbYAOWQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbYAOWQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:16:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32852 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753334AbYAOWQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:16:26 -0500
Date: Tue, 15 Jan 2008 23:16:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-ID: <20080115221627.GC1565@elf.ucw.cz>
References: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> the core of this patch series.
> add /dev/mem_notify device for notification low memory to user process.
> 
> <usage examle>
> 
>         fd = open("/dev/mem_notify", O_RDONLY);
>         if (fd < 0) {
>                 exit(1);
>         }
>         pollfds.fd = fd;
>         pollfds.events = POLLIN;
>         pollfds.revents = 0;
> 	err = poll(&pollfds, 1, -1); // wake up at low memory
> 
>         ...
> </usage example>

Nice, this is really needed for openmoko, zaurus, etc....

But this changelog needs to go into Documentation/...

...and /dev/mem_notify is really a bad name. /dev/memory_low?
/dev/oom?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
