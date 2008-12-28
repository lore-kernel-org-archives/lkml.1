Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYL1NmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYL1NmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 08:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYL1Nl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 08:41:58 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:55761 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbYL1Nl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 08:41:57 -0500
Date: Sun, 28 Dec 2008 16:41:55 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Pavel Machek <pavel@suse.cz>
Cc: Evgeniy Polyakov <zbe@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pohmelfs@ioremap.net, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [1/9] pohmelfs: documentation.
Message-ID: <20081228134155.GB858@ioremap.net>
References: <1230301130-1325-1-git-send-email-zbe@ioremap.net> <1230301130-1325-2-git-send-email-zbe@ioremap.net> <20081226192219.GB1761@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226192219.GB1761@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel.

On Fri, Dec 26, 2008 at 08:22:20PM +0100, Pavel Machek (pavel@suse.cz) wrote:
> > + * Flexible object architecture optimized for network processing.
> > +	Ability to create long paths to objects and remove arbitrarily huge
> > +	directories with a single network command.
> > +	(like removing the whole kernel tree via a single network
> > command).
> 
> Hmm, so we'll need new unlink_recursively() syscall?

If we could have it, it would be really simple in POHMELFS :)

> > + * Very high performance.
> 
> Do you have some nfs comparison?

Alot (nfs, xfs, pohmelfs with crypto, data and metadata IO)...

http://tservice.net.ru/~s0mbre/blog/devel/fs/2008_06_13_1.html
http://tservice.net.ru/~s0mbre/blog/devel/fs/2008_07_07.html
http://tservice.net.ru/~s0mbre/blog/devel/fs/2008_06_25.html
http://tservice.net.ru/~s0mbre/blog/devel/fs/2008_06_19_1.html

One can find more at old development track:
http://tservice.net.ru/~s0mbre/blog//devel/fs

-- 
	Evgeniy Polyakov
