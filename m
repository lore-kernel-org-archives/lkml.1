Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab0CKRAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:00:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933279Ab0CKRAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:00:46 -0500
Date: Thu, 11 Mar 2010 16:08:51 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Please pull UDF updates for 2.6.34-rc1
Message-ID: <20100311150851.GD4245@quack.suse.cz>
References: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain>
 <20100309162804.GB7373@atrey.karlin.mff.cuni.cz>
 <20100309091313.c568ef5a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309091313.c568ef5a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-03-10 09:13:13, Randy Dunlap wrote:
> On Tue, 9 Mar 2010 17:28:04 +0100 Jan Kara wrote:
> > > It's out there now. I still have a few trees I already got pull requests 
> > > for, and that I want to look over a bit more (ceph, gdb tree etc), and 
> > > it's possible that I've just overlooked some other pull request.
> >   It seems you haven't pulled my UDF tree (requested on Thursday -
> > http://lkml.indiana.edu/hypermail/linux/kernel/1003.0/02186.html).
> >   I've rebased the tree on top of 2.6.34-rc1 so could you please pull
> > now?
> >   The full pull request for your convenience:
> > 
> >   could you please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus
> > 
> >   to get:
> > 
> > Akinobu Mita (1):
> >       udf: use ext2_find_next_bit
> > 
> > Jan Kara (2):
> >       udf: Fix unalloc space handling in udf_update_inode
> >       udf: Do not read inode before writing it
> > 
> > The diffstat is
> > 
> >  fs/udf/balloc.c |   49 +------------------------------------------------
> >  fs/udf/inode.c  |   34 +++++++++++++++++-----------------
> >  2 files changed, 18 insertions(+), 65 deletions(-)
> 
> I have no objections, fwiw, but please change the $subject line...
  OK, changing the subject line to catch attention.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
