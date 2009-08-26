Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbZHZAok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbZHZAok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932721AbZHZAoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:44:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbZHZAoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:44:38 -0400
Date: Wed, 26 Aug 2009 02:44:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090826004430.GR4300@elf.ucw.cz>
References: <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz> <4A94812C.5010803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A94812C.5010803@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> THESE devices have the property of potentially corrupting blocks being
>>>> written at the time of the power failure,
>>>
>>> this is true of all devices
>>
>> Actually I don't think so. I believe SATA disks do not corrupt even
>> the sector they are writing to -- they just have big enough
>> capacitors. And yes I believe ext3 depends on that.
>
> Pavel, no S-ATA drive has capacitors to hold up during a power failure 
> (or even enough power to destage their write cache). I know this from 
> direct, personal knowledge having built RAID boxes at EMC for years. In 
> fact, almost all RAID boxes require that the write cache be hardwired to 
> off when used in their arrays.

I never claimed they have enough power to flush entire cache -- read
the paragraph again. I do believe the disks have enough capacitors to
finish writing single sector, and I do believe ext3 depends on that.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
