Return-Path: <linux-kernel-owner+w=401wt.eu-S965624AbXAXCwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965624AbXAXCwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965629AbXAXCwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:52:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:46003 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965624AbXAXCv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:51:59 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz>
	<877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz>
	<87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz>
	<87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz>
Date: Wed, 24 Jan 2007 03:51:56 +0100
In-Reply-To: <20070123184432.GE18662@elf.ucw.cz> (Pavel Machek's message of "Tue\, 23 Jan 2007 19\:44\:32 +0100")
Message-ID: <873b61cf1v.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

   Imagine for a moment that we solve time-warp somehow. Any other
   problems? 

Well, a user-level daemon have to process a lot of data just to detect user
interaction. Considering that the trackpad bandwidth is nearly 5KB/sec,
probably would be better to leave my panel alone... :-/

   I'd really like to get "is user idle" solved, but it really should not be in
   kernel unless it _has_ to. And time-warp probably causes problems not only
   for your daemon.

IMHO signal the user-space is a kernel duty and no user-space daemon will ever
make it better. There are plenty of PM daemons out there, but Linux still lacks
of a decent power management. Thanks to SIN, acpid and a silly bash script I'm
able to save a lot of battery and furthermore, when my friends see the dimming
panel they break out: WOW, how do you succeed in running MacOS on your Vaio!?!
:-(

Best,

-- 
Gratitude is not only the greatest of virtues, but the parent of all the
others. - Cicero
