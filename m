Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498Ab0ALMXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab0ALMXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 07:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233Ab0ALMXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 07:23:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0ALMXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 07:23:45 -0500
Date: Tue, 12 Jan 2010 13:23:46 +0100
From: Jan Kara <jack@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Thomas Voegtle <tv@lio96.de>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] quota: fix reserved space management for ordinary fs
Message-ID: <20100112122346.GD3125@quack.suse.cz>
References: <20100107180449.GA17495@suse.de>
 <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
 <20100107194131.GA22983@suse.de>
 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
 <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
 <20100107220213.GA24882@suse.de>
 <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
 <87wrztpgbh.fsf_-_@openvz.org>
 <20100108124139.GC3354@quack.suse.cz>
 <20100108155215.GA11358@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108155215.GA11358@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-01-10 07:52:15, Greg KH wrote:
> On Fri, Jan 08, 2010 at 01:41:39PM +0100, Jan Kara wrote:
> > On Fri 08-01-10 03:53:54, Dmitry Monakhov wrote:
> > > 
> > > In fact inode_get_rsv_space() function is special in comparison
> > > with inode_{add,sub,claim}_rsv_space() functions, because
> > > it may return correct result even for fs without reserved space
> > > support(correct val == 0). Add trivial check for that case.
> > > The patch fix regression(BUG at fs/quota/dquot.c:1350) introduced
> > > in following commit: fd8fbfc1709822bd94247c5b2ab15a5f5041e103
> > > 
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> >   Acked-by: Jan Kara <jack@suse.cz>
> > 
> > Greg, please merge this patch to stable series. I'll push the same
> > patch I have in my tree to Linus on Monday.
> 
> I can't merge it to the -stable tree until it shows up in Linus's tree,
> so I'll wait for that to happen.
  OK, Linus has pulled. It's commit
05b5d898235401c489c68e1f3bc5706a29ad5713. Please include it in both stable
trees that have the commit fd8fbfc1709822bd94247c5b2ab15a5f5041e103.
Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
