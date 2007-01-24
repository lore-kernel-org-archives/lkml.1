Return-Path: <linux-kernel-owner+w=401wt.eu-S965610AbXAXCCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610AbXAXCCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965611AbXAXCCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:02:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:57769 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965610AbXAXCCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:02:32 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: "Scott Preece" <sepreece@gmail.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz>
	<877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz>
	<87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz>
	<7b69d1470701231134k4e3e8a4dj2b95a230fa3da81c@mail.gmail.com>
Date: Wed, 24 Jan 2007 03:02:29 +0100
In-Reply-To: <7b69d1470701231134k4e3e8a4dj2b95a230fa3da81c@mail.gmail.com> (Scott Preece's message of "Tue\, 23 Jan 2007 13\:34\:11 -0600")
Message-ID: <877ivdchca.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Scott Preece" <sepreece@gmail.com> writes:

   My own hot button is making sure that the definition of what
   constitutes user activity is managed in exactly one place, whether in
   the kernel or not. My naive model would be to put the response at user
   level, but to provide a single point of definition in the kernel (say,
   /dev/useractivity or the equivalent) that the user-level daemon could
   listen to.

Unfortunately the term "user activity" seems a bit too vague for this. IMHO
different users (but also applications) present different needs that you cannot
fit with a single device node.

Example. The user expects that the keyboard light is turned off after 10
minutes of keyboard inactivity, disregarding the mouse movements. This makes
sense since the glare at the bottom disturb the Quake sessions. :-) However when
the screen is blanked, the user expects that either keyboard or mouse events
can unblank it...

-- 
All of the significant battles are waged within the self. - Sheldon Kopp
