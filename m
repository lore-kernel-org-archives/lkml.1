Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYIJVPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYIJVPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYIJVPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:15:10 -0400
Received: from styx.suse.cz ([82.119.242.94]:57901 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbYIJVPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:15:09 -0400
Date: Wed, 10 Sep 2008 23:15:07 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] UDF fix for 2.6.27-rc5
Message-ID: <20080910211507.GA21384@duck.suse.cz>
References: <20080910090620.GB19506@duck.suse.cz> <alpine.LFD.1.10.0809101105240.3384@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809101105240.3384@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-09-08 11:06:35, Linus Torvalds wrote:
> On Wed, 10 Sep 2008, Jan Kara wrote:
> > 
> >   would you please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus
> > 
> >   to get the following fix:
> > 
> > Christoph Hellwig (1):
> >       udf: add llseek method
> > 
> >  fs/udf/file.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> This is not AT ALL what I get when I pull. I get
> 
>   udf: Fix error paths in udf_new_inode()
>   udf: Fix lock inversion between iprune_mutex and alloc_mutex (v2)
> 
> which is
> 
>  fs/udf/ialloc.c |   44 +++++++++++++++++++-------------------------
>  1 files changed, 19 insertions(+), 25 deletions(-)
> 
> Hmm?
  Thanks for catching this. I managed to make two mistakes - first I forgot
to push changes to master.kernel.org and second I forgot to push older
changes to you after sending them for review to LKML. So a second try :).
Would you please pull

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

to get:

Christoph Hellwig (1):
      udf: add llseek method

Jan Kara (2):
      udf: Fix lock inversion between iprune_mutex and alloc_mutex (v2)
      udf: Fix error paths in udf_new_inode()

The diffstat is:
  fs/udf/file.c   |    1 +
  fs/udf/ialloc.c |   44 +++++++++++++++++++-------------------------
  2 files changed, 20 insertions(+), 25 deletions(-)

  Thanks.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
