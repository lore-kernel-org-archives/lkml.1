Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYBCVwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYBCVwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYBCVwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:52:33 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52534 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYBCVwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:52:33 -0500
Date: Sun, 3 Feb 2008 22:52:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] x86 PM: Consolidate suspend and hibernation code
Message-ID: <20080203215236.GG2648@uranus.ravnborg.org>
References: <200802032141.56887.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802032141.56887.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 09:41:56PM +0100, Rafael J. Wysocki wrote:
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

All looks good from my angle.

I would have deferred first patch until step 3 but no need to change
that now.
And I like the simplification of the arch/x86/Makefile
and the resulting kernel/power/Makefile.

	Sam
