Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYBCVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYBCVWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYBCVWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:22:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57847 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbYBCVWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:22:22 -0500
Date: Sun, 3 Feb 2008 22:22:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/4] x86 PM: Consolidate suspend and hibernation code
Message-ID: <20080203212236.GA2574@elf.ucw.cz>
References: <200802032141.56887.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802032141.56887.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-02-03 21:41:56, Rafael J. Wysocki wrote:
> Hi,
> 
> This series of patches consolidates the x86 suspend and hibernation code.
> It does the following:
> - move 64-bit hibernation/suspend files to arch/x86/power (under different
>   names)
> - rename 32-bit files in arch/x86/power in line with the 64-bit files
> - separate hibernation-specific 64-bit code from the code used for both
>   suspend and hibernation and simplify the Makefile
> - fix up comments
> Details are in the changelogs.
> 
> These patches don't introduce any functional changes.
> 
> Please review (and consider for merging if they look good :-)).

ACK, and thanks... It would make merges easier if this could go in
soon...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
