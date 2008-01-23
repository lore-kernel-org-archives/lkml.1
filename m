Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147AbYAWJvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbYAWJvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYAWJvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:51:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49297 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYAWJvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:51:06 -0500
To: miklos@szeredi.hu
CC: a.p.zijlstra@chello.nl, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <E1JHc0S-00027S-8D@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 23 Jan 2008 10:34:52 +0100)
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
	sys_msync()
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083504-git-send-email-salikhmetov@gmail.com>
	 <1201078035.6341.45.camel@lappy> <1201078278.6341.47.camel@lappy> <E1JHc0S-00027S-8D@pomaz-ex.szeredi.hu>
Message-Id: <E1JHcG4-0002A9-46@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Jan 2008 10:51:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also, it still doesn't make sense to me why we'd not need to walk the
> > rmap, it is all the same file after all.
> 
> It's the same file, but not the same memory map.  It basically depends
> on how you define msync:
> 
>  a) sync _file_ on region defined by this mmap/start/end-address
>  b) sync _memory_region_ defined by start/end-address

My mmap/msync tester program can acually check this as well, with the
'-f' flag.  Anton, can you try that on the reference platforms?

Miklos
