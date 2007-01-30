Return-Path: <linux-kernel-owner+w=401wt.eu-S965299AbXA3MdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299AbXA3MdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965301AbXA3MdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:33:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:52065 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965299AbXA3MdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:33:13 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz>
	<873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz>
	<878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz>
	<20070127192034.GA17652@suse.cz> <874pqanddd.fsf@gmx.it>
	<20070129222833.GB17330@elf.ucw.cz> <87odoho3pb.fsf@gmx.it>
	<20070130094205.GA2888@suse.cz>
Date: Tue, 30 Jan 2007 13:33:10 +0100
In-Reply-To: <20070130094205.GA2888@suse.cz> (Vojtech Pavlik's message of "Tue\, 30 Jan 2007 10\:42\:05 +0100")
Message-ID: <87ireowv7d.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik <vojtech@suse.cz> writes:

   On Mon, Jan 29, 2007 at 11:42:08PM +0100, Alessandro Di Marco wrote:

   > OK, but what about the time-warp problem?. To fix it I need to know when the
   > system goes to sleep/resumes. In SIN I've solved via the platform driver,
   > introducing suspend() resume() callbacks...

   Well, you just need to make sure that a resume() actually is a visible
   event ...

Sorry, but I don't see the point. Visible to what? 

Mine problem here is that the input device doesn't care about suspend/resume
cycles (it is a straight char driver), probably because it doesn't need to (so
far.) Low-level drivers (kbd & co) on the contrary are all bus or platform
drivers, hooking directly into suspend/resume callbacks.

Do you mean that I should back-propagate a suspend/resume event from the
low-level drivers to the input one?

-- 
There is only one thing a philosopher can be relied upon to do, and that is to
contradict other philosophers. - William James
