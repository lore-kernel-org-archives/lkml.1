Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYAFHgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYAFHgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 02:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYAFHgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 02:36:11 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60014 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYAFHgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 02:36:10 -0500
To: w@1wt.eu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712232344.JBJ90661.FQOFtFOVLJHSOM@I-love.SAKURA.ne.jp>
	<20071231200247.GA30373@sergelap.austin.ibm.com>
	<200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
	<200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
	<20080106062609.GC20753@1wt.eu>
In-Reply-To: <20080106062609.GC20753@1wt.eu>
Message-Id: <200801061636.GFE34382.FLtOMSOFHVOFJQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 6 Jan 2008 16:36:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Willy Tarreau wrote:
> Your patch is very confusing. In your description, as well as in the
> comments you talk about tmpfs, but your patch does not touch even one
> line of tmpfs and only changes ramfs. Even your variables and arguments
> refer to tmpfs. The Kconfig entry indicates that the feature depends
> on TMPFS too.
> 
> Judging from the following comment :
>   * Original tmpfs doesn't set ramfs_dir_inode_operations.setattr field.
> 
> I suspect that you confuse both filesystems.
>   - ramfs is in fs/ramfs and is always compiled in, you cannot disable it
>   - tmpfs is in mm/shmem.c and is optional. It also supports options that
>     ramfs does not (eg: size) and data may be swapped.
> 
> Please understand that I'm not discussing the usefulness of your patch,
> I'm just trying to avoid a huge confusion.

Oh, I thought the filesystem mounted by "mount -t tmpfs none /tmp" is "tmpfs"
and the source code of "tmpfs" is located in fs/ramfs directory.
So, I should write the description as "an extension to ramfs" rather than
"an extension to tmpfs".
I'll fix it in next posting.

Thank you.
