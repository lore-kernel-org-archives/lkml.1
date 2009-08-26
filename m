Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZHZAQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZHZAQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbZHZAQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:16:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36574 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbZHZAQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:16:53 -0400
Date: Wed, 26 Aug 2009 02:16:46 +0200
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
Message-ID: <20090826001645.GN4300@elf.ucw.cz>
References: <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A947DA9.2080906@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-08-25 20:11:21, Ric Wheeler wrote:
> On 08/25/2009 07:53 PM, Pavel Machek wrote:
>>> Why don't you hold all of your most precious data on that single S-ATA
>>> drive for five year on one box and put a second copy on a small RAID5
>>> with ext3 for the same period?
>>>
>>> Repeat experiment until you get up to something like google scale or the
>>> other papers on failures in national labs in the US and then we can have
>>> an informed discussion.
>>
>> I'm not interested in discussing statistics with you. I'd rather discuss
>> fsync() and storage design issues.
>>
>> ext3 is designed to work on single SATA disks, and it is not designed
>> to work on flash cards/degraded MD RAID5s, as Ted acknowledged.
>
> You are simply incorrect, Ted did not say that ext3 does not work
> with MD raid5.

http://lkml.org/lkml/2009/8/25/312
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
