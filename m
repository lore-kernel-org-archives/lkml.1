Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZHJMvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZHJMvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZHJMvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:51:14 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:54583 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbZHJMvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:51:13 -0400
Subject: Re: linux-next: nfs tree build warning
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090810105806.266011df.sfr@canb.auug.org.au>
References: <20090810105806.266011df.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 08:51:09 -0400
Message-Id: <1249908669.8060.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 2 total rcpts 1015 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 67BE02532533FCA8D0D236B4F1C65861591E1052
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 114 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 10:58 +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> fs/nfs/write.c: In function 'nfs_migrate_page':
> fs/nfs/write.c:1601: warning: unused variable 'inode'
> 
> Introduced by commit 1ec000f4f76ea914aa4ac57f8cec53fa958bd477 ("NFS: Add
> a ->migratepage() aop for NFS").

Oops, you're right. I'll fix that...

Trond

