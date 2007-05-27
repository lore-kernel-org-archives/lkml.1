Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXE0P6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXE0P6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbXE0P56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:57:58 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:56959 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbXE0P55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:57:57 -0400
Date: Sun, 27 May 2007 16:57:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <20070527155738.GA20006@srcf.ucam.org>
References: <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 03:53:28PM -0700, Linus Torvalds wrote:

> And I repeat: PowerPC had working and stable suspend five _years_ ago, 
> without any of that freezing crud. We should rip it out.

As far as I can tell the PPC code simply shuts down the devices without 
worrying about userspace at all. If this was reliable, what prevents us 
from simply disabling the freezer for STR?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
