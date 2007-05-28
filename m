Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbXE1BFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbXE1BFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbXE1BFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:05:23 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:52198 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbXE1BFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:05:22 -0400
Date: Mon, 28 May 2007 02:05:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Message-ID: <20070528010506.GA24186@srcf.ucam.org>
References: <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org> <20070527164300.GA20355@srcf.ucam.org> <200705272032.15971.rjw@sisk.pl> <20070527184402.GA21161@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070527184402.GA21161@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 07:44:02PM +0100, Matthew Garrett wrote:

> Anyway. I've tested the following patch on a dual-core x86. No obvious 
> issues yet, but I'll try to put it through a few hundred cycles.

This /mostly/ works - I've had my test machine cycling through a suspend 
cycle every 10 seconds for the past hour without any difficulties 
providing I unload USB first. If USB is loaded, the suspend occasionally 
fails with one of the devices returning -EBUSY and causing it to be 
aborted. I haven't looked into this in any detail yet, but it's 
presumably sufficiently generic code that it's potentially biting people 
on PPC anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
