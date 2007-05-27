Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbXE0QnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbXE0QnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbXE0QnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:43:13 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:36476 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbXE0QnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:43:12 -0400
Date: Sun, 27 May 2007 17:43:00 +0100
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
Message-ID: <20070527164300.GA20355@srcf.ucam.org>
References: <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org> <20070527155738.GA20006@srcf.ucam.org> <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 09:26:00AM -0700, Linus Torvalds wrote:

> And by "disabling the freezer", I think we should just not call it at all. 
> However, sadly, right now it's called from common code. I'll happily take 
> a tested patch to split that code sequence up, and try to do it in 2.6.23, 
> if somebody has the energy (I'm getting to the point where I may just do 
> it myself, but my lazy nature still hopes for a STR person to step 
> forward).

I'll take a look at this. It probably makes sense to build on Rafael's 
work on splitting the codepaths up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
