Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838Ab0AHPxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0AHPxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315Ab0AHPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:53:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab0AHPw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:52:59 -0500
Date: Fri, 8 Jan 2010 07:52:15 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Thomas Voegtle <tv@lio96.de>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] quota: fix reserved space management for ordinary fs
Message-ID: <20100108155215.GA11358@suse.de>
References: <alpine.LNX.2.00.1001071522480.5426@er-systems.de> <20100107180449.GA17495@suse.de> <alpine.LNX.2.00.1001072033301.26784@er-systems.de> <20100107194131.GA22983@suse.de> <alpine.LNX.2.00.1001072125040.26784@er-systems.de> <alpine.LNX.2.00.1001072141340.26784@er-systems.de> <20100107220213.GA24882@suse.de> <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com> <87wrztpgbh.fsf_-_@openvz.org> <20100108124139.GC3354@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108124139.GC3354@quack.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 01:41:39PM +0100, Jan Kara wrote:
> On Fri 08-01-10 03:53:54, Dmitry Monakhov wrote:
> > 
> > In fact inode_get_rsv_space() function is special in comparison
> > with inode_{add,sub,claim}_rsv_space() functions, because
> > it may return correct result even for fs without reserved space
> > support(correct val == 0). Add trivial check for that case.
> > The patch fix regression(BUG at fs/quota/dquot.c:1350) introduced
> > in following commit: fd8fbfc1709822bd94247c5b2ab15a5f5041e103
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>   Acked-by: Jan Kara <jack@suse.cz>
> 
> Greg, please merge this patch to stable series. I'll push the same
> patch I have in my tree to Linus on Monday.

I can't merge it to the -stable tree until it shows up in Linus's tree,
so I'll wait for that to happen.

thanks,

greg k-h
