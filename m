Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbZDAUw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbZDAUw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZDAUwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:52:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39773 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZDAUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:52:16 -0400
Date: Wed, 1 Apr 2009 22:52:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Bodo Eggert <7eggert@gmx.de>,
       Artem Bityutskiy <dedekind@yandex.ru>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in
	UBIFS)
Message-ID: <20090401205201.GI17808@elf.ucw.cz>
References: <ckjPq-2Dl-15@gated-at.bofh.it> <cl2jy-65z-1@gated-at.bofh.it> <cl2CZ-6q2-21@gated-at.bofh.it> <cl2N9-6Bj-9@gated-at.bofh.it> <E1LolUc-0003kM-FU@be1.7eggert.dyndns.org> <20090401000657.GH15063@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401000657.GH15063@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-31 20:06:57, Theodore Tso wrote:
> On Tue, Mar 31, 2009 at 11:27:33PM +0200, Bodo Eggert wrote:
> > This can be done using implicit logic:
> > 
> > ->E.g. on close(), mark inodes without being sync()ed as poisoned.
> > (I can think of more sophisticated logic, but ...)
> > ->On completing the inode with the delayed allocations, unpoison it.
> > ->Don't commit rename()s if the corresponding inode is poisoned.
> 
> Send us patches if you think it's that easy to do what you are
> proposing.   I assure it's not easy.

Well, implementing replace() syscall would be quite easy. Would you
want such a patch?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
