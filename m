Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbZH0G6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbZH0G6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 02:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZH0G6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 02:58:38 -0400
Received: from sandeen.net ([209.173.210.139]:28021 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZH0G6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 02:58:37 -0400
X-Greylist: delayed 1831 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 02:58:37 EDT
Message-ID: <4A962774.9000604@redhat.com>
Date: Wed, 26 Aug 2009 23:28:04 -0700
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, david@lang.hm, Pavel Machek <pavel@ucw.cz>,
       Rik van Riel <riel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net, jack@suse.cz
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm> <20090826131028.GB1370@ucw.cz> <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm> <20090826180248.GB6997@mit.edu>
In-Reply-To: <20090826180248.GB6997@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 06:43:24AM -0700, david@lang.hm wrote:
>>>> as the ext3 authors have stated many times over the years, you still need
>>>> to run fsck periodicly anyway.
>>> Where is that documented?
>> linux-kernel mailing list archives.
> 
> Probably from some 6-8 years ago, in e-mail postings that I made.  My
> argument has always been that PC-class hardware is crap, and it's a
> Really Good Idea to periodically check the metadata because corruption
> there can end up causing massive data loss.  The main problem is that
> doing it at reboot time really hurt system availability, and "after 20
> reboots (plus or minus)" resulted in fsck checks at wildly varying
> intervals depending on how often people reboot.

Aside ... can we default mkfs.ext3 to not set a mandatory fsck interval 
then? :)

-Eric

> What I've been recommending for some time is that people use LVM, and
> run fsck on a snapshot every week or two, at some convenient time when
> the system load is at a minimum.  There is an e2croncheck script in
> the e2fsprogs sources, in the contrib directory; it's short enough
> that I'll attach here here.
> 
> Is it *necessary*?  In a world where hardware is perfect, no.  In a
> world where people don't bother buying ECC memory because it's 10%
> more expensive, and PC builders use the cheapest possible parts --- I
> think it's a really good idea.
> 
> 						- Ted
