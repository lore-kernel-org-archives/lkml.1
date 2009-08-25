Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZHYJeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZHYJeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZHYJeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:34:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34344 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZHYJeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:34:20 -0400
Date: Tue, 25 Aug 2009 11:34:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090825093414.GB15563@elf.ucw.cz>
References: <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A932B18.1020209@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> If your concern is that with Linux MD, you could potentially lose an
>>> entire stripe in RAID 5 mode, then you should say that explicitly; but
>>> again, this isn't a filesystem specific cliam; it's true for all
>>> filesystems.  I don't know of any file system that can survive having
>>> a RAID stripe-shaped-hole blown into the middle of it due to a power
>>> failure.
>>>     
>>
>> Again, ext2 handles that in a way user expects it.
>>
>> At least I was teached "ext2 needs fsck after powerfail; ext3 can
>> handle powerfails just ok".
>
> So, would you be happy if ext3 fsck was always run on reboot (at least  
> for flash devices)?

For flash devices, MD Raid 5 and anything else that needs it; yes that
would make me happy ;-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
