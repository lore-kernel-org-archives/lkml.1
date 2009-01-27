Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZA0KyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZA0KyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZA0Kxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:53:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56448 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZA0Kxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:53:52 -0500
Date: Tue, 27 Jan 2009 11:53:38 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Victor Pelt <victor.pelt@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ext4 no space left
Message-ID: <20090127105338.GA21011@elf.ucw.cz>
References: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com> <20090121145513.GH31253@mit.edu> <576cb9750901210718u32aa98ecy87e7298a0f3444f@mail.gmail.com> <20090121170423.GJ31253@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121170423.GJ31253@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-01-21 12:04:23, Theodore Tso wrote:
> On Wed, Jan 21, 2009 at 04:18:35PM +0100, Victor Pelt wrote:
> > i set the number mounted counter to 31, which forced fsck to run on
> > the next reboot. I rebooted, fsck didn't show any erros, but i still
> > got the no space left error when i tried to copy files to the
> > partition.
> 
> OK, if a reboot didn't help, I'll bet I know what happened.  E2fsprogs
> changed the default default inode ratio, which means that number of
> inodes being created is half what it was previously.  If you do a "df
> -i", you'll probably see that you have exhausted the number of inodes
> in the filesystem.

Actually it would be cool if df warned about low inode free space by
default. "df -i" is an old trap, but still effective to these days
:-).
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
