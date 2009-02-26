Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZBZEKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZBZEKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 23:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZBZEJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 23:09:53 -0500
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:63660 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZBZEJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 23:09:53 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tomas@slax.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1LcH0H-00016K-Im@pomaz-ex.szeredi.hu>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl> <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu> <15922.1235492819@jrobl> <E1LcH0H-00016K-Im@pomaz-ex.szeredi.hu>
Date: Thu, 26 Feb 2009 13:09:29 +0900
Message-ID: <7306.1235621369@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> I'd personally be more motivated to review <2000 line chunks (where
> each step adds new functionality and makes sense in itself), than a
> 20000 line filesystem all in one.

That is reasonable. :-)


> Perhaps it's easier, but copy-up is a very inefficient operation, both
> in disk space and in time.  My personal opinion is that a "delta"

I have to agree again.


> But that's just a thought, I haven't gone too deeply into this.
> 
> > If you say "just a part of write" goes to a new fs, then I don't think
> > we can support several essential features, for instance mmap.
> 
> It should be possible to support mmap.

In a easy way?
I know you already wrote it is just a thought, but if you have an idea
to support mmapping a file which is distributed multiple filesystems,
please let me know.


J. R. Okajima
