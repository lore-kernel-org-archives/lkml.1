Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZBXNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZBXNTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZBXNTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:19:06 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:42614 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZBXNTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:19:05 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tomas@slax.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu>
Date: Tue, 24 Feb 2009 22:18:10 +0900
Message-ID: <11287.1235481490@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> I think the biggest problem is too many features.
> 
>    > git diff master...aufs2 | diffstat
>     ...
>     73 files changed, 23527 insertions(+), 7 deletions(-)
>                       ^^^^^^
> This is an unreviewable amount of code, it would make AUFS one of the
> biggest filesystems on linux.
> 
> The first step would be to separate out the very core functionality,
> which should be a couple thousands of lines max.  And when that has
> been accepted and stabilised, then you can start adding fancy
> features.

I have to admit aufs is big, but actually, as I wrote in the documents,
aufs2 has already dropped several features. And I believe it is the core
feature set. If aufs2 drops some more features, then both of users and
reviewers will say it doesn't work in this case, in that case. I don't
think you would like to review such unusable code in real world.
For those who wants to begin with aufs2 principle (or basic
architecture), I described and posted these documents.

Actually ocfs2 and xfs are much bigger.
If they have been reviewed, I'd ask you to review aufs2 too.
$ cd linux/fs
$ for i in *; do test -d $i && echo -n $i && find $i -type f | xargs wc -l | tail -1; done | tr -s '[[:blank:]]' | sort -n -k 2 | tail
nfs 30363 total
ntfs 31346 total
jfs 33056 total
cifs 34059 total
ubifs 34721 total
btrfs 43417 total
aufs 46325 total
nls 54855 total
ocfs2 71294 total
xfs 102144 total


J. R. Okajima
