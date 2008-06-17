Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYFQRDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYFQRDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYFQRCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:02:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57321 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYFQRCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:02:53 -0400
To: szaka@ntfs-3g.org
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, ywang221@hotmail.com
In-reply-to: <Pine.LNX.4.62.0806171950350.23306@tamago.serverit.net> (message
	from Szabolcs Szakacsits on Tue, 17 Jun 2008 19:59:15 +0300 (EEST))
Subject: Re: [2.6.26 patch] fuse: fix thinko in max I/O size calucation
References: <E1K8dgi-0005sl-El@pomaz-ex.szeredi.hu> <Pine.LNX.4.62.0806171950350.23306@tamago.serverit.net>
Message-Id: <E1K8eZX-0006B3-Kb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Jun 2008 19:02:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Use max not min to enforce a lower limit on the max I/O size.
> 
> Big write is ok now, thanks. NTFS-3G in-memory write performance seems to 
> be 6x better on a T9300 and quick tests seem to show that it's at least as 
> fast as ext3 in-memory writes (but this needs more testing, etc).
> 
> However the max write size seems to be limited to 128kB. Is this 
> intentional?

Yes, that's due to another limit (max 32 pages per request).

Miklos
