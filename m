Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYBCX4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYBCX4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYBCXzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:55:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32956 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753567AbYBCXzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:55:52 -0500
Date: Mon, 4 Feb 2008 00:56:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080203235608.GH2799@elf.ucw.cz>
References: <20080130120111.GB22820@elf.ucw.cz> <20080203181648.GA1629@elf.ucw.cz> <200802032333.02821.rjw@sisk.pl> <200802040020.14836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802040020.14836.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Below is the arch/x86/kernel/acpi/sleep.c part without the warnings (untested).
> 
> It still contains some hardcoded magic numbers and extern declarations, so
> I guess the #include list is not complete or another header is necessary.
> 
> BTW:
> 1) why exactly is acpi_wakeup_address not (void *)?
> 2) header->level3_ident_pgt and header->level3_ident_pgt could be (char *) IMO

I applied it, and renamed acpi/rm to acpi/realmode... yep, rm was a
bad name.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
