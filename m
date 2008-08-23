Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYHWNLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYHWNLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYHWNLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:11:33 -0400
Received: from tau.jukie.net ([216.239.93.128]:36511 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYHWNLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:11:32 -0400
Date: Sat, 23 Aug 2008 09:11:31 -0400
From: Bart Trojanowski <bart@jukie.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] document additional vfat mount options
Message-ID: <20080823131131.GE28029@jukie.net>
References: <20080823031229.GA28029@jukie.net> <1219461278-26776-1-git-send-email-bart@jukie.net> <87tzdcfm2g.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzdcfm2g.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> [080822 23:27]:
> Thanks. Fixed. Current patch is the following.

Indeed, I have made some mistakes.

Now that I read it again...

> +gid=###       -- Explisitly set ownership of all files on this
> +                 filesystem to this group ID number.  Default is to use
> +                 the GID of the mounting process.

... it has a 'explicit' typo, spotted by Ian Ward, and it's not setting
ownership, but rather group ownership.  So how about this

gid=###       -- Explicitly set group ownership of all files on this
                 filesystem to this group ID number.  Default is to use
                 the GID of the mounting process.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
