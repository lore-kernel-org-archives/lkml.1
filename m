Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZICIzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZICIzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZICIza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:55:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48997 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZICIz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:55:29 -0400
Date: Thu, 3 Sep 2009 10:55:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Rob Landley <rob@landley.net>, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090903085510.GE3793@elf.ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <20090902201210.GC1840@ucw.cz> <4A9ED8AB.5080003@redhat.com> <200909021800.51096.rob@landley.net> <alpine.DEB.2.00.0909021605100.28411@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909021605100.28411@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> However, thinking about how to _fix_ a problem is predicated on acknowledging
>> that there actually _is_ a problem.  "The hardware is not physically damaged
>> but your data was lost" sounds to me like a software problem, and thus
>> something software could at least _attempt_ to address.  "There's millions of
>> 'em, Linux can't cope" doesn't seem like a useful approach.
>
> no other OS avoids this problem either.
>
> I actually don't see how you can do this from userspace, because when you 
> write to the device you have _no_ idea where on the device your data will 
> actually land.

It certainly is not easy. Self-correcting codes could probably be
used, but that would be very special, very slow, and very
non-standard. (Basically... we could design filesystem so that it
would survive damage of arbitrarily 512K on disk -- using
self-correcting codes in CD-like manner). I'm not sure if it would be
practical.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
