Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbYDNH0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbYDNH0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbYDNH0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:26:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37846 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbYDNH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:26:06 -0400
To: dwmw2@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <1208121358.2700.4.camel@shinybook.infradead.org> (message from
	David Woodhouse on Sun, 13 Apr 2008 22:15:58 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	 <20080412170304.54f139e2.akpm@linux-foundation.org>
	 <20080413033344.GA27494@hash.localnet>
	 <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org>
Message-Id: <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Apr 2008 09:25:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 2008-04-13 at 12:37 +0200, Miklos Szeredi wrote:
> > There's one thing which makes fuse a slightly better candidate for
> > applications where the number of users is low: stability.  Unless you
> > or your users test the hell out of your filesystem, there always a
> > chance that some bugs will remain.  These rarely bring down the whole
> > system, but it usually requires a reboot to let you continue using the
> > Oopsing fs.
> 
> I think it's a slippery slope from that to rewriting Linux as a
> microkernel.

You say that as if a microkernel had _no_ advantages.  Which isn't
true: it's just a trade between performance and encapsulation.  What I
was saying, that if there are few users, and so the tester base is
limited, then they _might_ just be better off with a slower, but more
stable solution.

I'm not advocating moving ext3 to fuse.  And I didn't advocate moving
ntfs to fuse, still that was done and the resulting filesystem at the
moment happens to outperform the kernel one in every respect ;)

Miklos
