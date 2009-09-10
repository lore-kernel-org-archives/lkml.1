Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZIJUHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZIJUHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZIJUHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:07:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56724 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbZIJUHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:07:33 -0400
Date: Thu, 10 Sep 2009 22:07:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org, apw@canonical.com,
       bonbons@linux-vserver.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <20090910200735.GX18599@kernel.dk>
References: <20090908193540.GB18599@kernel.dk> <60772f633c524ba873f569966fccd6ce@coraid.com> <20090909180804.3e62331a@lxorguk.ukuu.org.uk> <30b7855d211ab5b6bef6fe2cd9b76295@coraid.com> <20090909205835.GK18599@kernel.dk> <810bbe1723b0a205f9b5018a5ddaa722@coraid.com> <20090910074820.GS18599@kernel.dk> <84f18127dcdb4762bf9dc6796846087f@coraid.com> <20090910195021.GW18599@kernel.dk> <aa669085856b88bee82d150efe84b682@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa669085856b88bee82d150efe84b682@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Ed Cashin wrote:
> On Thu Sep 10 15:50:23 EDT 2009, jens.axboe@oracle.com wrote:
> > On Thu, Sep 10 2009, Ed Cashin wrote:
> ...
> > > I think the EOPNOTSUPP patch is good for the for-next aoe quilt tree,
> > > while the new barrier support will be good for 2.6.32.
> > 
> > .31 is already out, so there's plenty of time to fix it for .32 for
> > real. I don't mind putting in the temporary fix in the mean time,
> > though.
> 
> I missed that.  It was still rc9 when I pulled earlier today, so I put
> the temporary fix into the aoe quilt tree for linux-next.
> 
> Now that 2.6.31 is out, I suppose this patch should be taken out of
> the aoe quilt tree for linux-next and submitted for inclusion in
> 2.6.31.1.
> 
> So, yes, if you don't mind pushing the patch to the appropriate place,
> that would be great.

Did you repost a non-whitespace damaged version?

> Now I have to figure out why the other patch in aoe's quilt tree for
> linux-next never made it to 2.6.31.

Things don't go from -next to mainstream automatically, -next is just a
testing base. You have to submit it explicitly, eg send it to me.

-- 
Jens Axboe

