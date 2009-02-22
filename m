Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZBVN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZBVN5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZBVN5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:57:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35565 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBVN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:57:06 -0500
Date: Sun, 22 Feb 2009 14:56:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Cyril Hrubi? <metan@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, thommycheck@gmail.com, milan@ucw.cz
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
Message-ID: <20090222135651.GD1387@ucw.cz>
References: <20090128113809.GA29424@elf.ucw.cz> <dc2200690902121322l4e16cf84h25d2871ca80c37a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc2200690902121322l4e16cf84h25d2871ca80c37a3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-02-12 22:22:37, Cyril Hrubi? wrote:
> Hi,
> 2.6.29-rc4 boots on spitz and looks overall good but framebuffer
> redraws some lines terribly slow. When I'm editing text in bash from
> the middle in some cases I can see redrawing the text pixel by pixel.
> And suspend to ram on pressing On/Off button does nothing now (some
> missing config option?).

Hmm, it gets worse: echo mem > /sys/power/state sleeps 2.6.28, but
there's no way to resume it.

About hda timeouts... I remember seeing them under older kernels, too,
under loads such as kernel compile... plus keypresses tend to get lost
under high loads :-(.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
