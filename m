Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887Ab0ALO0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0ALO0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020Ab0ALO0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:26:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:40662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab0ALO0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:26:10 -0500
Date: Tue, 12 Jan 2010 06:24:36 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Thomas Voegtle <tv@lio96.de>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] quota: fix reserved space management for ordinary fs
Message-ID: <20100112142436.GC25426@suse.de>
References: <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
 <20100107194131.GA22983@suse.de>
 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
 <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
 <20100107220213.GA24882@suse.de>
 <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
 <87wrztpgbh.fsf_-_@openvz.org>
 <20100108124139.GC3354@quack.suse.cz>
 <20100108155215.GA11358@suse.de>
 <20100112122346.GD3125@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112122346.GD3125@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 01:23:46PM +0100, Jan Kara wrote:
> On Fri 08-01-10 07:52:15, Greg KH wrote:
> > On Fri, Jan 08, 2010 at 01:41:39PM +0100, Jan Kara wrote:
> > > On Fri 08-01-10 03:53:54, Dmitry Monakhov wrote:
> > > > 
> > > > In fact inode_get_rsv_space() function is special in comparison
> > > > with inode_{add,sub,claim}_rsv_space() functions, because
> > > > it may return correct result even for fs without reserved space
> > > > support(correct val == 0). Add trivial check for that case.
> > > > The patch fix regression(BUG at fs/quota/dquot.c:1350) introduced
> > > > in following commit: fd8fbfc1709822bd94247c5b2ab15a5f5041e103
> > > > 
> > > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > >   Acked-by: Jan Kara <jack@suse.cz>
> > > 
> > > Greg, please merge this patch to stable series. I'll push the same
> > > patch I have in my tree to Linus on Monday.
> > 
> > I can't merge it to the -stable tree until it shows up in Linus's tree,
> > so I'll wait for that to happen.
>   OK, Linus has pulled. It's commit
> 05b5d898235401c489c68e1f3bc5706a29ad5713. Please include it in both stable
> trees that have the commit fd8fbfc1709822bd94247c5b2ab15a5f5041e103.

Great, will do.

thanks for the followup.

greg k-h
