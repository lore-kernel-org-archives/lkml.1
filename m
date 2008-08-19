Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbYHSDie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbYHSDie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 23:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYHSDiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 23:38:25 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:48454 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYHSDiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 23:38:24 -0400
Date: Mon, 18 Aug 2008 22:37:11 -0500
From: David Fries <david@fries.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i486 CR4 oops, no_console_suspend
Message-ID: <20080819033710.GD17528@spacedout.fries.net>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818064120.GA28941@elte.hu>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 18 Aug 2008 22:37:20 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 08:41:20AM +0200, Ingo Molnar wrote:
> 
> applied to tip/x86/urgent, thanks David. I've changed the conditions to 
> read_cr4_safe() instead - that's cleaner. Could you please check whether 
> the patch below works fine too on your box?

Yes the 486 suspends and resumes with this patch.

Is there any known problem with no_console_suspend and serial
consoles?  It worked to print the oops for me to track this down, and
Documentation/kernel-parameters.txt says it is known to work with
serial consoles, but on resume only kernel messages can output to the
serial console.  The getty on the serial port can't raed or write and
processes trying to write to the port just hang without getting any
data across.  The serial port works fine across suspends without
the no_console_suspend argument.  Does anyone else see this?

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
