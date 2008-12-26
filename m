Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYL1HoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYL1HoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 02:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYL1Hn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 02:43:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36710 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYL1Hn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 02:43:56 -0500
Date: Fri, 26 Dec 2008 20:22:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: Evgeniy Polyakov <zbe@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pohmelfs@ioremap.net, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Eveniy Polyakov <zbr@ioremap.net>
Subject: Re: [1/9] pohmelfs: documentation.
Message-ID: <20081226192219.GB1761@ucw.cz>
References: <1230301130-1325-1-git-send-email-zbe@ioremap.net> <1230301130-1325-2-git-send-email-zbe@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230301130-1325-2-git-send-email-zbe@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +Homepage: http://www.ioremap.net/projects/pohmelfs
> +
> +POHMELFS first began as a network filesystem with coherent local data and
> +metadata caches but is now evolving into a parallel distributed filesystem.
> +
> +Main features of this FS include:
> + * Locally coherent cache for data and metadata with (potentially) byte-range locks.
> +	Since all Linux filesystems lock the whole inode during writing, algorithm
> +	is very simple and does not use byte-ranges, although they are sent in
> +	locking messages.
> + * Completely async processing of all events except creation of hard and symbolic
> +	links, and rename events.
> +	Object creation and data reading and writing are processed asynchronously.
> + * Flexible object architecture optimized for network processing.
> +	Ability to create long paths to objects and remove arbitrarily huge
> +	directories with a single network command.
> +	(like removing the whole kernel tree via a single network
> command).

Hmm, so we'll need new unlink_recursively() syscall?

> + * Very high performance.

Do you have some nfs comparison?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
