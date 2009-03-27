Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbZC0WxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbZC0WxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbZC0Wwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:52:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138AbZC0Wwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:52:47 -0400
Date: Fri, 27 Mar 2009 23:52:43 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tytso@mit.edu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] Quota changes for 2.6.30
Message-ID: <20090327225243.GK31071@duck.suse.cz>
References: <20090326012207.GG11024@duck.suse.cz> <alpine.LFD.2.00.0903261616210.3032@localhost.localdomain> <20090327201227.GA31071@duck.suse.cz> <alpine.LFD.2.00.0903271448520.3994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903271448520.3994@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 27-03-09 14:52:11, Linus Torvalds wrote:
> On Fri, 27 Mar 2009, Jan Kara wrote:
> > On Thu 26-03-09 16:16:47, Linus Torvalds wrote:
> > > 
> > > 
> > > On Thu, 26 Mar 2009, Jan Kara wrote:
> > > > 
> > > >   could you please pull from
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git for_linus
> > > 
> > > 	"Already up-to-date."
> > > 
> > > Forgot to actually push it out?
> >   Damn, you're right. Should be there now.
> 
> It is, but now when I pull I notice that you hadn't used "-M --summary" 
> when asking me to pull. You claimed:
> 
> 	 66 files changed, 4770 insertions(+), 4565 deletions(-)
> 
> but in fact it's really:
> 
> 	 58 files changed, 902 insertions(+), 697 deletions(-)
> 	 create mode 100644 fs/quota/Kconfig
> 	 create mode 100644 fs/quota/Makefile
> 	 rename fs/{ => quota}/dquot.c (85%)
> 	 rename fs/{ => quota}/quota.c (94%)
> 	 rename fs/{ => quota}/quota_tree.c (84%)
> 	 rename fs/{ => quota}/quota_tree.h (100%)
> 	 rename fs/{ => quota}/quota_v1.c (79%)
> 	 rename fs/{ => quota}/quota_v2.c (98%)
> 	 rename fs/{ => quota}/quotaio_v1.h (100%)
> 	 rename fs/{ => quota}/quotaio_v2.h (100%)
> 
> so please do change your pull-request script to add -M (for rename 
> detection) and --summary (for that "new, deleted and renamed files" 
> summary at the end).
  OK, I didn't know this is the preferred way. Will do next time.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
