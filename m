Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZAMOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZAMOkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZAMOkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:40:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52084 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZAMOkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:40:31 -0500
Date: Tue, 13 Jan 2009 15:42:33 +0100
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz, tytso@mit.edu
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090113144233.GC1983@elf.ucw.cz>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113134503.41318144@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-13 13:45:03, Alan Cox wrote:
> > Plus it has a nasty behaviour where it reverts to -W1 if disk
> > connection is momentarily lost. (If you unplug/replug SATA disk, linux
> > will happily rediscover and use it, but -W0 was already forgotten at
> > that point, right?)
> 
> If you momentarily lose power your disk state isn't defined anyway. If
> you do that with the SATA code it should treat it the same as a scsi disk
> swap so it'll get a new device and the old fs will go down.

No, that is not what happened :-(. If I replug disk within 10 seconds,
it just behaves as if nothing happened, and continues operating on the
disk. AMD machine... but I don't think that matters.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
