Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbYBCX7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbYBCX7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYBCX7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:59:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35215 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753773AbYBCX7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:59:09 -0500
Date: Mon, 4 Feb 2008 00:59:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080203235927.GK2799@elf.ucw.cz>
References: <20080130120111.GB22820@elf.ucw.cz> <200802040020.14836.rjw@sisk.pl> <20080203233313.GF2799@elf.ucw.cz> <200802040054.43863.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802040054.43863.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> BTW, I don't like the way in which the 'struct wakeup_header' fields are
> reproduced in rm/wakeup.S very much, because it makes the code fragile.
> It might be better to define the offsets in asm-offsets*.c and refer to them
> relative to wakeup_header (if possible).

If you can do that.. yes, that would be nice. I triple-checked it, but
indeed is fragile.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
