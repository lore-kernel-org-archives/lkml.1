Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbYBUArs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbYBUArs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbYBUArj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:47:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYBUArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:47:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=WramDpCVWbDSznxX+2MM3N/Qs2a8dpTjbzfHWYlfGHmvD+yocCyECqqtPECPeuGBY
	D13EO5FVT09TqEm3llLjw==
Message-ID: <6599ad830802201647h37772fd1k4f9bbe1a200a5833@mail.gmail.com>
Date: Wed, 20 Feb 2008 16:47:20 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 7/7] cgroup: remove dead code in cgroup_get_rootdir()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
In-Reply-To: <47B91C89.4080508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B91C89.4080508@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/17 Li Zefan <lizf@cn.fujitsu.com>:
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

>  ---
>   kernel/cgroup.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
>  diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index 71cf961..879a056 100644
>  --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -926,7 +926,6 @@ static int cgroup_get_rootdir(struct super_block *sb)
>         if (!inode)
>                 return -ENOMEM;
>
>  -       inode->i_op = &simple_dir_inode_operations;
>         inode->i_fop = &simple_dir_operations;
>         inode->i_op = &cgroup_dir_inode_operations;
>         /* directories start off with i_nlink == 2 (for "." entry) */
>  --
>  1.5.4.rc3
>
>
