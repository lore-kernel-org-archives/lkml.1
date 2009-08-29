Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZH2KTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZH2KTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZH2KTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:19:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZH2KTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:19:03 -0400
Date: Sat, 29 Aug 2009 11:38:04 +0200
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
Message-ID: <20090829093804.GD1634@ucw.cz>
References: <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A9481BE.1030308@redhat.com> <20090826003803.GP4300@elf.ucw.cz> <4A9485A6.1010803@redhat.com> <20090826112121.GD26595@elf.ucw.cz> <4A952370.50603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A952370.50603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Example I seen went like this:
>>
>> Drive in raid 5 failed; hot spare was available (no idea about
>> UPS). System apparently locked up trying to talk to the failed drive,
>> or maybe admin just was not patient enough, so he just powercycled the
>> array. He lost the array.
>>
>> So while most people will not agressively powercycle the RAID array,
>> drive failure still provokes little tested error paths, and getting
>> unclean shutdown is quite easy in such case.
>
> Then what we need to document is do not power cycle an array during a  
> rebuild, right?

Yep, that and the fact that you should fsck if you do.

> If it wasn't the admin that timed out and the box really was hung (no  
> drive activity lights, etc), you will need to power cycle/reboot but  
> then you should not have this active rebuild issuing writes either...

Ok, I guess you are right here.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
