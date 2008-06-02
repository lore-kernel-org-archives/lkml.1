Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYFBJzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYFBJzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYFBJzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:55:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40196 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYFBJzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:55:35 -0400
Date: Mon, 2 Jun 2008 10:53:10 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stas Sergeev <stsp@aknet.ru>, ambx1@neo.rr.com, bjorn.helgaas@hp.com,
       david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
Message-ID: <20080602095310.GB20222@flint.arm.linux.org.uk>
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org> <483BEF1A.3080808@aknet.ru> <20080528163600.b4c3c12c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528163600.b4c3c12c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 04:36:00PM -0700, Andrew Morton wrote:
> On Tue, 27 May 2008 15:23:06 +0400
> Stas Sergeev <stsp@aknet.ru> wrote:
> 
> > RTC doesn't work with pnpacpi=off.
> > The attached patch fixes the problem by creating the platform device for
> > the RTC when PNP is disabled. This may also help running the PNP-enabled
> > kernel on an older PCs.
> > 
> > Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> > Cc: David Brownell <david-b@pacbell.net>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Cc: Adam Belay <ambx1@neo.rr.com>
> > CC: Russell King <rmk+lkml@arm.linux.org.uk>
> 
> So is everyone happy with this now?

No idea - I've been away for the last week, and thanks to the extensive
discussions on linux-arch and the private threads, I've now got literally
hundreds of emails to work through.

Plus I'm rather tired today, thanks to power cuts setting off peoples
burgular alarms during last night.  And I'm probably not around much
tomorrow nor Wednesday...

You get the picture - probably about a week or so before I can even get
around to thinking about testing this (or indeed much else.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
