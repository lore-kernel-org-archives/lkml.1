Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZIAU0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZIAU0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZIAU0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:26:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56128 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZIAU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:26:21 -0400
Date: Tue, 1 Sep 2009 15:58:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090901135846.GC2028@ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <4A97BC9E.5070801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A97BC9E.5070801@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Interesting. So, what's technically wrong with the patch below?
>
> My suggestion was that you stop trying to document your assertion of an 
> issue and actually suggest fixes in code or implementation. I really 
> don't think that you have properly diagnosed your specific failure or 
> done sufficient. However, if you put a full analysis and suggested code 
> out to the MD devel lists, we can debate technical implementation as we 
> normally do.

I don't think I should be required to rewrite linux md layer in order
to fix documentation. 

> The only note that I would put in ext3/4 etc documentation would be:
>
> "Reliable storage is important for any file system. Single disks (or 
> FLASH or SSD) do fail on a regular basis.

Uh, how clever, instead of documenting that our md raid code does not
always work as expected, you document that components fail. Newspeak
101?

You even failed to mention little design problem with flash and
eraseblock size... and the fact that you don't need flash to fail to
get data loss.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
