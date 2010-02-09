Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0BINDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:03:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab0BINDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:03:06 -0500
Subject: Re: linux-next: manual merge of the fsnotify tree with the vfs tree
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100209054521.GK30031@ZenIV.linux.org.uk>
References: <20100209163708.b7ae6d05.sfr@canb.auug.org.au>
	 <20100209054521.GK30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 08:02:54 -0500
Message-ID: <1265720575.18730.24.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 05:45 +0000, Al Viro wrote:
> On Tue, Feb 09, 2010 at 04:37:08PM +1100, Stephen Rothwell wrote:
> > Hi Eric,
> > 
> > Today's linux-next merge of the fsnotify tree got a conflict in
> > fs/namei.c between commit 123df2944c436c80640c4281c5bc9c7950b18687 ("Lose
> > the new_name argument of fsnotify_move()") from the vfs tree and commit
> > 2df5764e29a813f6ba63be094ab8aadc704a78fd ("fsnotify: use unsigned char *
> > for dentry->d_name.name") from the fsnotify tree.
> > 
> > The former removed the code changed by the latter, so I used the former.
> 
> FWIW, I've put two commits (audit_inode_child and fsnotify_move ones) into
> a new not-for-rebase branch (for-fsnotify) and told Eric, so hopefully
> he'll just pull it into fsnotify tree.

I know I merged it yesterday, but now I can't for the life of me find
the branch I merged it onto, obviously it wasn't my for-next branch.
I'm so confused.  Anyway, yes, I'll merge it again right now.....

-Eric


