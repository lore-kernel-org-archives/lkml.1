Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZHZLPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZHZLPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZHZLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:15:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54463 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269AbZHZLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:15:44 -0400
Date: Wed, 26 Aug 2009 13:15:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rik van Riel <riel@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090826111537.GB26595@elf.ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <19092.28371.793339.764701@notabene.brown> <20090825234454.GI4300@elf.ucw.cz> <4A94B529.1080308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A94B529.1080308@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> Ok, can you help? Having a piece of MD documentation explaining the
>> "powerfail nukes entire stripe" and how current filesystems do not
>> deal with that would be nice, along with description when exactly that
>> happens.
>
> Except of course for the inconvenient detail that a power
> failure on a degraded RAID 5 array does *NOT* nuke the
> entire stripe.

Ok, you are right. It will nuke unrelated sector somewhere on the
stripe (one that is "old" and was not recently written) -- which is
still something ext3 can not reliably handle.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
