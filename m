Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYE1Xiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYE1Xiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYE1XiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:38:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbYE1XiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:38:21 -0400
Date: Wed, 28 May 2008 16:36:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stas Sergeev <stsp@aknet.ru>
Cc: ambx1@neo.rr.com, bjorn.helgaas@hp.com, david-b@pacbell.net, mingo@elte.hu,
       tglx@linutronix.de, dbrownell@users.sourceforge.net,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
Message-Id: <20080528163600.b4c3c12c.akpm@linux-foundation.org>
In-Reply-To: <483BEF1A.3080808@aknet.ru>
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org>
	<483BEF1A.3080808@aknet.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 15:23:06 +0400
Stas Sergeev <stsp@aknet.ru> wrote:

> RTC doesn't work with pnpacpi=off.
> The attached patch fixes the problem by creating the platform device for
> the RTC when PNP is disabled. This may also help running the PNP-enabled
> kernel on an older PCs.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: Adam Belay <ambx1@neo.rr.com>
> CC: Russell King <rmk+lkml@arm.linux.org.uk>

So is everyone happy with this now?

It got lost from the changelog but IIRC this fixes a small sort-of regression
which was added in 2.6.25(?) because Stas switched drivers.  I assume
that the incompatibility was unintentional.

So it might be 2.6.26 material, and possibly even 2.6.25.x?
