Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbXE1NEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbXE1NEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbXE1NDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:03:55 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:37297 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXE1NDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:03:54 -0400
Date: Mon, 28 May 2007 14:03:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Message-ID: <20070528130343.GB29738@srcf.ucam.org>
References: <1180008394.15600.26.camel@localhost> <20070527184402.GA21161@srcf.ucam.org> <20070528010506.GA24186@srcf.ucam.org> <200705281011.17338.rjw@sisk.pl> <20070528121056.GA29143@srcf.ucam.org> <20070528125507.GI18807@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528125507.GI18807@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 02:55:07PM +0200, Pavel Machek wrote:

> Well, PPC people are aware of this, and they think they can fix the
> drivers. We probably want to drop the freezer for suspend long-term,
> so. PPC machines use small subset of all the drivers, so it apparently
> is not big problem for them.

I'm fairly certain that PPC uses USB. In any case, it's not limited to 
PPC - APM has the same issue. Any driver that assumes processes will be 
frozen during suspend to RAM is broken now, not the future.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
