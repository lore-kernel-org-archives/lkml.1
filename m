Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZA0Qdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZA0Qdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZA0Qdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:33:32 -0500
Received: from styx.suse.cz ([82.119.242.94]:41975 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752571AbZA0Qdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:33:32 -0500
Date: Tue, 27 Jan 2009 17:33:30 +0100
From: Jan Kara <jack@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch false positive?
Message-ID: <20090127163330.GD8289@duck.suse.cz>
References: <20090127154904.GC8289@duck.suse.cz> <20090127081954.47609e46@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127081954.47609e46@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-01-09 08:19:54, Arjan van de Ven wrote:
> On Tue, 27 Jan 2009 16:49:05 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> >   Hi,
> > 
> >   I've used checkpatch.pl to verify one of my patches. It complains:
> > 
> > ERROR: trailing statements should be on next line
> > #167: FILE: fs/quota/quota_tree.c:249:
> > +       for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
> > [...]
> >              i++, ddquot += info->dqi_entry_size);
> > 
> >   But the code looks like:
> >         for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
> >              i < qtree_dqstr_in_blk(info)
> > && !qtree_entry_unused(info, ddquot); i++, ddquot +=
> > info->dqi_entry_size);
> > 
> 
> while tihs might be correct C... don't you think it would be much
> better to actually have a statement here rather than cramming
> everything into the for ?
  This is an old code and I was just wrapping lines to fit into 80 chars...
But you're right, I can rewrite the loop into more readable form when I'm
at it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
