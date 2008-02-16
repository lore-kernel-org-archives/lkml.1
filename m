Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYBTLeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYBTLeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 06:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYBTLdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 06:33:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4736 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751126AbYBTLdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 06:33:51 -0500
Date: Sat, 16 Feb 2008 17:20:49 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
Message-ID: <20080216172048.GB3979@ucw.cz>
References: <20080214162104.GA5347@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214162104.GA5347@ics.muni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> whom should I blame about disk schedulers?
> 
> I have the following setup:
> 1Gb network
> 2GB RAM
> disk write speed about 20MB/s
> 
> If I'm scping file (about 500MB) from the network (which is faster than the
> local disk), any process is totally unable to read anything from the local disk
> till the scp finishes. It is not caused by low free memory, while scping
> I have 500MB of free memory (not cached or buffered).
> 
> I tried cfq and anticipatory scheduler, none is different.

Is cat /dev/zero > file enough to reproduce this?

ext3 filesystem?

Will cat /etc/passwd work while machine is unresponsive?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
