Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXFMNib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXFMNib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXFMNhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:37:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2823 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755005AbXFMNht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:37:49 -0400
Date: Tue, 12 Jun 2007 15:02:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Gary Zambrano <zambrano@broadcom.com>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [1/3] 2.6.22-rc4: known regressions v2
Message-ID: <20070612150221.GB5986@ucw.cz>
References: <466AE606.7020704@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466AE606.7020704@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Can we add 'writing to /proc/acpi/thermal/*/trip_points' no longer
works to the list? Len did it intentionally but that does not make it
right. People are using it and we did not go through deprecation
period. Plus there's no reasonable alternative.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
