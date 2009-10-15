Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZJOGbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZJOGbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZJOGbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:31:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57062
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbZJOGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:31:44 -0400
Date: Wed, 14 Oct 2009 23:31:40 -0700 (PDT)
Message-Id: <20091014.233140.56663130.davem@davemloft.net>
To: npiggin@suse.de
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, raven@themaw.net,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mszeredi@suse.cz
Subject: Re: [patch 2/6] fs: no games with DCACHE_UNHASHED
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091015050048.165912589@suse.de>
References: <20091015044026.319860788@suse.de>
	<20091015050048.165912589@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: npiggin@suse.de
Date: Thu, 15 Oct 2009 15:40:28 +1100

> (this is in -mm)
> 
> Filesystems outside the regular namespace do not have to clear DCACHE_UNHASHED
> in order to have a working /proc/$pid/fd/XXX. Nothing in proc prevents the
> fd link from being used if its dentry is not in the hash.
> 
> Also, it does not get put into the dcache hash if DCACHE_UNHASHED is clear;
> that depends on the filesystem calling d_add or d_rehash.
> 
> So delete the misleading comments and needless code.
> 
> Acked-by: Miklos Szeredi <mszeredi@suse.cz>
> Signed-off-by: Nick Piggin <npiggin@suse.de>

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
