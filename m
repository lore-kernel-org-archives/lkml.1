Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbXCIWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbXCIWKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXCIWKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:10:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56736 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752760AbXCIWKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:10:36 -0500
Date: Fri, 9 Mar 2007 23:10:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Message-ID: <20070309221022.GA1818@elf.ucw.cz>
References: <200703072044.12021.rjw@sisk.pl> <20070307210716.GA4913@ucw.cz> <20070309122934.GA8412@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309122934.GA8412@osiris.boeblingen.de.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...so, if pm_ops is non-null, power_down does nonboot cpu disabling,
> > otherwise we proceed with cpus enabled?
> > 
> > That looks ugly.
> > 
> > Is the warning bogus? Or maybe we should *always* disable nonboot cpus
> > in powerdown path?
> 
> Is disable_nonboot_cpus() assuming that first_cpu(cpu_present_map) is
> the boot cpu? Just wondering why disable_nonboot_cpus() isn't using just

I'd  say so. It is nicer (and required on some APM systems?) to do
shutdown from the boot cpu.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
