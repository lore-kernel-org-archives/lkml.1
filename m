Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYEQBOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYEQBOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYEQBOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:14:38 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:54724 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbYEQBOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:14:37 -0400
To: miklos@szeredi.hu, akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 17/22] vfs: add path_symlink()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080516163136.560107038@szeredi.hu>
	<20080516163237.755590775@szeredi.hu>
In-Reply-To: <20080516163237.755590775@szeredi.hu>
Message-Id: <200805171014.JJC34315.MOFSFQHOJFtLOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 17 May 2008 10:14:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> -int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)
> +static int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname, int mode)

I think the "mode" parameter is not needed
unless somebody has a plan to pass it to "struct inode_operations"->symlink method.
