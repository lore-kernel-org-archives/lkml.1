Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbXCLU7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbXCLU7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXCLU7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:59:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4270 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752930AbXCLU73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:59:29 -0400
Date: Mon, 12 Mar 2007 20:58:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Johnson <ajohnson@intrinsyc.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO+KD_GRAPHICS mode
Message-ID: <20070312205848.GB4945@ucw.cz>
References: <1173731380.30345.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173731380.30345.33.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When the console is in VT_AUTO+KD_GRAPHICS mode, switching to the
> SUSPEND_CONSOLE fails, resulting in vt_waitactive() waiting indefinitely
> or until the task is interrupted.  This patch tests if a console switch
> can occur in set_console() and returns early if a console switch is not
> possible.

> Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>

ACK. (I hope it still applies to latest mainline).
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
