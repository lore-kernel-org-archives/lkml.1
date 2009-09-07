Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZIGTpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZIGTpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZIGTpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:45:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZIGTpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:45:31 -0400
Date: Mon, 7 Sep 2009 21:45:31 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data v2
Message-ID: <20090907194531.GD29103@duck.suse.cz>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-4-git-send-email-jens.axboe@oracle.com> <20090904105403.GD19857@duck.suse.cz> <20090904115858.GT18599@kernel.dk> <20090904120407.GV18599@kernel.dk> <20090907183659.GB29103@duck.suse.cz> <20090907184517.GF18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907184517.GF18599@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-09-09 20:45:18, Jens Axboe wrote:
> On Mon, Sep 07 2009, Jan Kara wrote:
> >   Hi Jens,
> > 
> >   now I've found just two minor things (see below). Besides them the only
> > thing which is blocking my ack is a way to effectively lookup a BDI from a
> > superblock so that we can reasonably effectively fsync a superblock...
> 
> Can we side step that as an inclusion criteria, please? I'd really like
> to work on adding that quick lookup, but I'd also hate to potentiall
> destabilize anything at this point. So we can probably quite easily make
> .32 as well for that, but I'd rather not risk doing a version and
> include that from the beginning. OK?
  Well, for now I thought about a simple hack like a pointer to
backing_dev_info in a superblock. That should work for every filesystem
right now and shouldn't be too complex...
  But if you promise you'll fix that up before 2.6.32 is released, I'm OK
with your patch as is. I'll give your patches some testing with some less
usual benchmarks this week and if that works out fine you have my ack.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
