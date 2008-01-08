Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYAHV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYAHV6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYAHV57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:57:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2801 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751718AbYAHV56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:57:58 -0500
Date: Tue, 8 Jan 2008 21:32:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108213225.GC5050@ucw.cz>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-01-08 16:07:27, Tuomo Valkonen wrote:
> 
> The ext3 journalling code can be summarised as:
> 
>     superblock->last_checked = random();
>     sync(superblock)
> 
> I hate it: every time Linux crashes, e.g. due to power failure, it takes
> almost an hour to boot, because the kernel has decided to corrupt the 
> superblock to indicate that it's been years since last file system 
> check. And obviously the crappy init system provides no simple way to 
> stop the checking, to put it in the background, or whatever. The FOSS 

rm /sbin/fsck?

And no, ext3 here does not corrupt last_checked here.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
