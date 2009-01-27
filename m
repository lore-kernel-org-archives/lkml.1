Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZA0K1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZA0K1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZA0K1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:27:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33537 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZA0K13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:27:29 -0500
Date: Tue, 27 Jan 2009 11:27:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Gergely Imreh <imrehg@gmail.com>
Subject: Re: [Bug #12391] Processor does not go below C2 state until
	usb.autosuspend is enabled
Message-ID: <20090127102715.GB20854@elf.ucw.cz>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.p8C._JRdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX2gZ6Cy9nC.A.p8C._JRdJB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-19 22:45:39, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12391
> Subject		: Processor does not go below C2 state until usb.autosuspend is enabled
> Submitter	: Gergely Imreh <imrehg@gmail.com>
> Date		: 2009-01-09 02:35 (11 days old)

Hmm? That would be quite expected behaviour. USB autosuspend is needed
for C3... (as soon as any USB device is plugged in, at least). Can you
doublecheck that 2.6.27 could run with C3 with active USB? That would
be small miracle...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
