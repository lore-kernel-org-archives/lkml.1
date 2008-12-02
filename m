Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYLBWst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYLBWst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYLBWsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:48:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40302 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYLBWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:48:40 -0500
Date: Tue, 2 Dec 2008 23:50:22 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Chris Friesen <cfriesen@nortel.com>,
       mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081202225022.GA8662@elf.ucw.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu> <20081202224403.GA8277@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202224403.GA8277@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



...and it is unsafe to run ext2/ext3 on any media that can return
error on write. That includes perfectly working disk drives that just
ran out of spare blocks.

> AFAICT it is unsafe to run ext2/ext3 on any media that can be removed
> without unmounting (missing fsync error propagation), and it is

To be fair, bad fsync semantics (error only reported to the first
person that asks) looks like fundamental Unix problem, nothing ext2/3
specific...

> to run ext2/ext3 on any flash-based storage with block interface (SD
> cards, flash sticks).

...and I'm aware of no filesystem that _can_ reliably work on SD
cards/USB flash sticks...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
