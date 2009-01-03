Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbZACW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbZACW2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZACW2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:28:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZACW2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:28:02 -0500
Date: Sat, 3 Jan 2009 23:29:57 +0100
From: Pavel Machek <pavel@suse.cz>
To: Duane Griffin <duaneg@dghda.com>
Cc: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090103222957.GG1666@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz> <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-01-03 22:17:15, Duane Griffin wrote:
> [Fixed top-posting]
> 
> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
> > Pavel Machek wrote:
> >> readonly mount does actually write to the media in some cases. Document that.
> >>
> > Can one avoid replay of the journal then if it would be unclean?
> > Just curious.
> 
> Nope. If the underlying block device is read-only then mounting the
> filesystem will fail. I tried to fix this some time ago, and have a
> set of patches that almost always work, but "almost always" isn't good
> enough. Unfortunately I never managed to figure out a way to finish it
> off without disgusting hacks or major surgery.

Uhuh, can you just ignore the journal and mount it anyway?
...basically treating it like an ext2?

...ok, that will present "old" version of the filesystem to the
user... violating fsync() semantics.

Still handy for recovering badly broken filesystems, I'd say.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
