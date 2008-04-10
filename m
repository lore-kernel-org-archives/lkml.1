Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYDJGaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYDJGaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYDJGaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:30:00 -0400
Received: from gw.c1.byte.nl ([82.94.214.64]:59803 "EHLO smtp.byte.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752465AbYDJG37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:29:59 -0400
Date: Thu, 10 Apr 2008 08:29:57 +0200 (CEST)
From: Allard Hoeve <allard@byte.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, Gertjan Oude Lohuis <gertjan@byte.nl>
Subject: Re: [patch] fix infinite loop in generic_file_splice_read()
In-Reply-To: <20080409115702.79737d7f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.62.0804100822240.12367@office2.c1.internal>
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu>
 <20080409115702.79737d7f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hallo Andrew, others,

> We found suspicious-looking code in generic_file_splice_read() back in 
> February.  See http://lkml.org/lkml/2008/2/29/443.  I suspect that patch 
> (if it works) will address the truncate lockup as well - it zaps the 
> loop entirely.
>
> Unfortunately Allard never got back to us (probably because he's running
> 2.6.24 which has a quite different generic_file_splice_read()) and the
> patch didn't get anywhere.

Unfortunately, we cannot test the patch on the server that triggered the 
bug in 2.6.24.2, because it's too critical for operation. On other similar 
servers the bug hasn't been encountered and we were unable to reproduce 
it, so it must be some combination of load and typical usage (NFS server).

We are now running 2.6.22.x, which does fine. I hope you understand our 
hesitation of running patched, known-bugged kernels on our fileservers :)

Thanks for all the bughunting here. There is a maintenance window soon, 
I'll try to put the original patch on the agenda.

Regards,

Allard Hoeve
