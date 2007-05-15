Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbXEPNhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbXEPNhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760810AbXEPNfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:35:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2076 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760521AbXEPNfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:35:52 -0400
Date: Tue, 15 May 2007 09:08:31 +0000
From: Pavel Machek <pavel@ucw.cz>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 35/45] Allow permission functions to tell between parent and leaf checks
Message-ID: <20070515090831.GB6816@ucw.cz>
References: <20070514110607.549397248@suse.de> <20070514110620.237075017@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514110620.237075017@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Set the LOOKUP_CONTINUE flag when checking parent permissions. This allows
> permission functions to tell between parent and leaf checks.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

I guess you should sign this off.


> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1409,6 +1409,10 @@ static int may_delete(struct inode *dir,
>  	BUG_ON(victim->d_parent->d_inode != dir);
>  	audit_inode_child(victim->d_name.name, victim->d_inode, dir);
>  
> +#if 0
> +	if (nd)
> +		nd->flags |= LOOKUP_CONTINUE;
> +#endif

We don't add disabled code to kernel.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
