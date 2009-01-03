Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbZACWEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbZACWEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759742AbZACWEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:04:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46792 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759634AbZACWEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:04:45 -0500
Date: Sat, 3 Jan 2009 23:06:38 +0100
From: Pavel Machek <pavel@suse.cz>
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       tytso@mit.edu, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090103220638.GF1666@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <495FD5D7.2040907@ribosome.natur.cuni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-01-03 22:17:11, Martin MOKREJŠ wrote:
> Can one avoid replay of the journal then if it would be unclean?
> Just curious.

Well, mounting unclean filesystem is dangerous but depending on
circumstances, it may be better than writing to the filesystems.

(You may not be able to read some data and may provoke kernel bugs,
but at least you don't damage what is on disk. If you are collecting
evidence -- not writing is very important. If you suspect something is
very wrong with the drive, not writing is good idea).

								Pavel
> 
> Pavel Machek wrote:
> > Using ext3 is only safe if storage subsystem meets certain
> > criteria. Document those.
> > 
> > Errors=remount-ro is documented as default, but superblock setting
> > overrides that and mkfs defaults to errors=continue... so the default
> > is errors=continue in practice.
> > 
> > readonly mount does actually write to the media in some cases. Document that.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
