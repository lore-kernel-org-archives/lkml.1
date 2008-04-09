Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYDITZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYDITZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYDITZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:25:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52354 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYDITZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:25:38 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, allard@byte.nl, neilb@suse.de
In-reply-to: <20080409115702.79737d7f.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 9 Apr 2008 11:57:02 -0700)
Subject: Re: [patch] fix infinite loop in generic_file_splice_read()
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu> <20080409115702.79737d7f.akpm@linux-foundation.org>
Message-Id: <E1JjfvC-0005Jn-GD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Apr 2008 21:25:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We found suspicious-looking code in generic_file_splice_read() back in
> February.  See http://lkml.org/lkml/2008/2/29/443.  I suspect that patch
> (if it works) will address the truncate lockup as well - it zaps the loop
> entirely.
> 
> Unfortunately Allard never got back to us (probably because he's running
> 2.6.24 which has a quite different generic_file_splice_read()) and the
> patch didn't get anywhere.
> 
> Here it is again.
> 
> It needs a changelog.
> 
> Nobody has tested this at all, to my knowledge.

Patch looks sane, and fixes the fsx-linux/NFS/fuse lockup, as expected.

Thanks,
Miklos
