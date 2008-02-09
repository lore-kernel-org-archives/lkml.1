Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYBIAZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYBIAZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbYBIAZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:25:18 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39782 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbYBIAZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:25:17 -0500
Date: Sat, 9 Feb 2008 02:25:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Adrian Bunk <bunk@kernel.org>, Miklos Szeredi <mszeredi@suse.cz>,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: uml compile error
Message-ID: <20080209002532.GG6505@cs181133002.pp.htv.fi>
References: <20080208223228.GD6505@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0802090102590.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802090102590.30873@twin.jikos.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 01:05:15AM +0100, Jiri Kosina wrote:
> On Sat, 9 Feb 2008, Adrian Bunk wrote:
> 
> > Commit dd2cc4dff3b08ab54c4c177a080046bcc84ac41d broke uml:
> > <-- snip  -->
> > ...
> >   CC      fs/hostfs/hostfs_kern.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c: In function 'hostfs_show_options':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c:328: error: dereferencing pointer to incomplete type
> > make[3]: *** [fs/hostfs/hostfs_kern.o] Error 1
> 
> I guess we need this one?
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> UML: fix hostfs build
>...

Thanks that fixed it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

