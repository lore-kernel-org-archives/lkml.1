Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbZHZBQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbZHZBQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbZHZBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:16:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47360 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbZHZBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:16:13 -0400
Date: Wed, 26 Aug 2009 03:16:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090826011605.GS4300@elf.ucw.cz>
References: <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826010018.GA17684@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 3) Does that mean that you shouldn't use ext3 on RAID drives?  Of
> course not!  First of all, Ext3 still saves you against kernel panics
> and hangs caused by device driver bugs or other kernel hangs.  You
> will lose less data, and avoid needing to run a long and painful fsck
> after a forced reboot, compared to if you used ext2.  You are making

Actually... ext3 + MD RAID5 will still have a problem on kernel
panic. MD RAID5 is implemented in software, so if kernel panics, you
can still get inconsistent data in your array.

I mostly agree with the rest.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
