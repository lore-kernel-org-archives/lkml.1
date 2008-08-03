Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYHCOxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYHCOxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYHCOxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:53:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59515 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbYHCOxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:53:30 -0400
Date: Sun, 3 Aug 2008 15:53:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches
Message-ID: <20080803145326.GT28946@ZenIV.linux.org.uk>
References: <20080801153655.GP28946@ZenIV.linux.org.uk> <adaod4aur6d.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaod4aur6d.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 07:08:42AM -0700, Roland Dreier wrote:
> Something seems a little strange about your git worflow, with patch
> descriptions such as
> 
>  >       [patch 3/4] vfs: remove unused nameidata argument of may_create()
> 
> making it in without the "[patch 3/4]" part being stripped, and even
> worse descriptions such as
> 
>  >       Re: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree
> 
> getting committed too....

git-am -k ...  FWIW, I tend to leave [patch...] alone; the second one slipped
unnoticed - usually I edit ones like that, including the subject.
