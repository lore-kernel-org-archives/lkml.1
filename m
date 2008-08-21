Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYHUESw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYHUESw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYHUESm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:18:42 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:39576 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYHUESl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:18:41 -0400
Date: Wed, 20 Aug 2008 23:17:21 -0500
From: David Fries <david@fries.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i486 CR4 oops, no_console_suspend
Message-ID: <20080821041721.GE17528@spacedout.fries.net>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu> <20080819033710.GD17528@spacedout.fries.net> <20080819093454.GG28713@elte.hu> <48AAEFBE.5060406@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAEFBE.5060406@zytor.com>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 20 Aug 2008 23:17:29 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 09:07:26AM -0700, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >
> >i've had trouble no end with getting even kernel messages out to the 
> >serial console during critical phases of suspend/resume. (especially in 
> >combination with earlyprintk=ttyS0 - not surprisingly)
> >
> >Especially during resume the UART is initialized back to something 
> >really slow - 300 bauds or 9600 bauds. (depends on the chipset i guess) 
> >So even though it works, it will only worked reliably when i 
> >standardized all my baud settings to that very low setting.
> >
> 
> Probably depends on the BIOS, actually; I suspect you end up with the 
> standard BIOS setting, which is *usually* 9600 bps.

I have grub, the kernel, and a getty all set to 115200, for suspend,
resume, or reboot it's always 115200.  With grub there's no BIOS
guessing, it sets it to a configured state.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
