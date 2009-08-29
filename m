Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbZH2KUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbZH2KUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZH2KUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:20:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53614 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZH2KUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:20:46 -0400
Date: Sat, 29 Aug 2009 11:39:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rik van Riel <riel@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090829093947.GE1634@ucw.cz>
References: <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A94B8FE.8050307@redhat.com> <20090826112219.GE26595@elf.ucw.cz> <4A954A98.5070808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A954A98.5070808@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-26 10:45:44, Rik van Riel wrote:
> Pavel Machek wrote:
>
>> Sledgehammer is hardware problem, and I'm demonstrating
>> software/documentation problem we have here.
>
> So your argument is that a sledgehammer is a hardware
> problem, while a broken hard disk and a power failure
> are software/documentation issues?
>
> I'd argue that the broken hard disk and power failure
> are hardware issues, too.

Noone told me that degraded md raid5 is dangerous. Thats documentation
issue #1. Maybe I just pulled the disk for fun.

ext3 docs told me that journal protects me against fs corruption
during power fails. It does not in this particular case. Seems like
docs issue #2. Maybe I just hit the reset button because it was there.

Randomly hitting power button may be stupid, but should not result in
filesystem corruption on reasonably working filesystem/storage stack.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
