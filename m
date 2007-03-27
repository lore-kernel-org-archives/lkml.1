Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXC0V0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXC0V0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965445AbXC0V0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:26:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2005 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965472AbXC0V0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:26:05 -0400
Date: Tue, 27 Mar 2007 21:24:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
Message-ID: <20070327212419.GA5817@ucw.cz>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This patch adds support for finding out the current file position,
> open flags and possibly other info in the future.
> 
> These new entries are added:
> 
>   /proc/PID/fdinfo/FD
>   /proc/PID/task/TID/fdinfo/FD
> 
> For each fd the information is provided in the following format:
> 
> pos:	1234
> flags:	0100002

Octal? Maybe we should use more traditional hex here? Or even list
flags by name?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
