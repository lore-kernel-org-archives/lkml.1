Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbXIHQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbXIHQdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXIHQdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:33:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2257 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753345AbXIHQdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:33:42 -0400
Date: Sat, 8 Sep 2007 16:33:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, Thomas Voegtle <tv@lio96.de>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [4/4] 2.6.23-rc5: known regressions v2
Message-ID: <20070908163328.GB4457@ucw.cz>
References: <46E27DEF.7060109@googlemail.com> <46E2835E.9010408@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E2835E.9010408@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Subject         : resume from ram much slower
> References      : http://lkml.org/lkml/2007/8/10/275
> Last known good : 2.6.23-rc1 ?
> Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
> Caused-By       : ?
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Status          : problem is being debugged

Can you try unloading acpi_cpufreq? I seen similar bug in suse
kernel...

If that does not help, try unloading as many modules as possible...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
