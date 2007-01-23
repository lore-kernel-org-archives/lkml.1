Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXAWRLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXAWRLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 12:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbXAWRLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 12:11:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:33020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933010AbXAWRLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 12:11:44 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz>
	<877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz>
	<87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz>
Date: Tue, 23 Jan 2007 18:11:38 +0100
In-Reply-To: <20070123163442.GA18662@elf.ucw.cz> (Pavel Machek's message of "Tue\, 23 Jan 2007 17\:34\:42 +0100")
Message-ID: <87lkjthdmd.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

   >    But I still believe it can be out.
   >
   > Do you believe it could be a user-space daemon or what?

   Yes, what prevents userspace daemon watching /dev/input/event* to
   provide this functionality?

Well that was my first attempt. Just an hack, but it works. Nonetheless I found
the kernel-level approach fitting better the problem: it is elegant, simpler
and more efficient than user-level one.

For example, the subsystem provides at kernel-level handy
hiberante/suspend/resume callbacks that I use to turn on/off the timer,
avoiding the time-warp problem. Doing that at user-level would be far more
messy...

Bye

--
An age is called Dark not because the light fails to shine, but because people
refuse to see it. - James Michener, Space
