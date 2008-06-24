Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYFXVph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYFXVph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYFXVp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:45:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44310 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbYFXVpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:45:25 -0400
Date: Tue, 24 Jun 2008 23:46:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86 ACPI: normalize segment descriptor register on
	resume
Message-ID: <20080624214610.GC18679@elf.ucw.cz>
References: <200806242303.49498.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806242303.49498.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: H. Peter Anvin <hpa@zytor.com>
> 
> x86 ACPI: normalize segment descriptor register on resume
> 
> Some Dell laptops enter resume with apparent garbage in the segment
> descriptor registers (almost certainly the result of a botched
> transition from protected to real mode.)  The only way to clean that
> up is to enter protected mode ourselves and clean out the descriptor
> registers.
> 
> This fixes resume on Dell XPS M1210 and Dell D620.
> 
> Reference: http://bugzilla.kernel.org/show_bug.cgi?id=10927
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks for great work.

I still consider this one slightly risky, and would like to get it as
much testing as possible, but all the risks are hypothetical and
regression from 2.6.25 is real, so...

Acked-by: Pavel Machek <pavel@suse.cz>

If this could be sneaked into Ingo's tree for some automated testing,
that would be good.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
