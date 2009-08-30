Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZH3PFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZH3PFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 11:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZH3PFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 11:05:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47163 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbZH3PFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 11:05:39 -0400
Date: Sun, 30 Aug 2009 17:05:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
       Ric Wheeler <rwheeler@redhat.com>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090830150536.GA6322@elf.ucw.cz>
References: <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-08-30 05:55:01, david@lang.hm wrote:
> On Sun, 30 Aug 2009, Pavel Machek wrote:
>
>>>> From: Theodore Tso <tytso@mit.edu>
>>>>
>>> To use your ABS brakes analogy, just becase it's not safe to rely on
>>> ABS brakes if the "check brakes" light is on, that doesn't justify
>>> writing something alarmist which claims that ABS brakes don't work
>>> 100% of the time, don't use ABS brakes, they're broken!!!!
>>
>> If it only was this simple. We don't have 'check brakes' (aka
>> 'journalling ineffective') warning light. If we had that, I would not
>> have problem.
>>
>> It is rather that your ABS brakes are ineffective if 'check engine'
>> (RAID degraded) is lit. And yes, running with 'check engine' for
>> extended periods may be bad idea, but I know people that do
>> that... and I still hope their brakes work (and believe they should
>> have won suit for damages should their ABS brakes fail).
>
> the 'RAID degraded' warning says that _anything_ you put on that block  
> device is at risk. it doesn't matter if you are using a filesystem with a 
> journal, one without, or using the raw device directly.

If you are using one with journal, you'll still need to run fsck at
boot time, to make sure metadata is still consistent... Protection
provided by journaling is not effective in this configuration.

(You have the point that pretty much all users of the blockdevice will
be affected by powerfail degraded mode.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
