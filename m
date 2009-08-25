Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbZHYX3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbZHYX3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbZHYX3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:29:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbZHYX3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:29:42 -0400
Date: Wed, 26 Aug 2009 01:29:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090825232934.GG4300@elf.ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <alpine.DEB.2.00.0908251600280.28411@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908251600280.28411@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> "ext3 works on flash and MD RAID5, as long as you do not have
>>>> powerfail" seems to be the accurate statement, and if you don't need
>>>> to protect against powerfails, you can just use ext2.
>>>
>>> Strange how your personal preference is totally out of sync with the
>>> entire enterprise class user base.
>>
>> Perhaps noone told them MD RAID5 is dangerous? You see, that's exactly
>> what I'm trying to document here.
>
> a MD raid array that's degraded to the point where there is no redundancy 
> is dangerous, but I don't think that any of the enterprise users would be 
> surprised.
>
> I think they will be surprised that it's possible that a prior failed  
> write that hasn't been scrubbed can cause data loss when the array later  
> degrades.

Cool, so Ted's "raid5 has highly undesirable properties" is actually
pretty accurate. Some raid person should write more detailed README,
I'd say...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
