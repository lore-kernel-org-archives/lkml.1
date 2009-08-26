Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZHZLWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZHZLWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZHZLW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:22:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33667 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbZHZLW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:22:28 -0400
Date: Wed, 26 Aug 2009 13:22:20 +0200
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
Message-ID: <20090826112219.GE26595@elf.ucw.cz>
References: <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A94B8FE.8050307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A94B8FE.8050307@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-26 00:24:30, Rik van Riel wrote:
> Pavel Machek wrote:
>
>> Look, I don't need full drive failure for this to happen. I can just
>> remove one disk from array. I don't need power failure, I can just
>> press the power button. I don't even need to rebuild anything, I can
>> just write to degraded array.
>>
>> Given that all events are under my control, statistics make little
>> sense here.
>
> I recommend a sledgehammer.
>
> If you want to lose your data, you might as well have some fun.
>
> No need to bore yourself to tears by simulating events that are
> unlikely to happen simultaneously to careful system administrators.

Sledgehammer is hardware problem, and I'm demonstrating
software/documentation problem we have here.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
