Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbXFNQu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbXFNQu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXFNQuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:50:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2789 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751063AbXFNQuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:50:15 -0400
Date: Thu, 14 Jun 2007 16:13:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO 1/9] Allow use of namespace_sem from LSM module.
Message-ID: <20070614161328.GB9442@ucw.cz>
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com> <4670EEF2.9010406@nttdata.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4670EEF2.9010406@nttdata.co.jp>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> TOMOYO Linux uses pathnames for auditing and controlling 
> file access.
> Therefore, namespace_sem is needed.
> 
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa 
> <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> ---------------
> fs/namespace.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -ubBpErN linux-2.6.21.5/fs/namespace.c 
> linux-2.6.21.5-tomoyo/fs/namespace.c
> --- linux-2.6.21.5/fs/namespace.c	2007-06-12 
> 03:37:06.000000000 +0900
> +++ linux-2.6.21.5-tomoyo/fs/namespace.c 2007-06-14 
> 15:02:38.000000000 +0900
> @@ -37,7 +37,7 @@ static int event;
> static struct list_head *mount_hashtable __read_mostly;
> static int hash_mask __read_mostly, hash_bits 
> __read_mostly;
> static struct kmem_cache *mnt_cache __read_mostly;
> -static struct rw_semaphore namespace_sem;
> +struct rw_semaphore namespace_sem;
> 

Looks whitespace-damaged to me.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
