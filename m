Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0BAOPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:15:24 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:50073 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0BAOPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:15:19 -0500
Subject: Re: linux-next: nfs tree build failure
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100201183838.63439783.sfr@canb.auug.org.au>
References: <20100201183838.63439783.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:15:13 -0500
Message-ID: <1265033714.2658.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 5 sum msgs/h 1 total rcpts 2329 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 31CB5DD210B563062D6D43EE324FB0BD31748887
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 148 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 18:38 +1100, Stephen Rothwell wrote: 
> Hi Trond,
> 
> Today's linux-next build (sparc defconfig) failed like this:
> 
> fs/nfs/write.c: In function 'nfs_wb_page':
> fs/nfs/write.c:1478: error: implicit declaration of function 'nfs_commit_inode'
> 
> Caused by commit d01b3158b56e292dbb3eea711a51a1d3dbec5094 ("NFS: Simplify
> nfs_wb_page()").  Neither CONFIG_NFS_V3 nor CONFIG_NFS_V4 is set in this
> build.
> 
> I have reverted that commit for today.

Hi Stephen,

Sorry. There was a 1 line change that somehow slipped out of the final
revision of the patch. It should be fixed now.

Cheers
  Trond

