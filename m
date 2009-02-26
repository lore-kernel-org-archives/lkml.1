Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbZBZFze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbZBZFze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZBZFzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:55:23 -0500
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:33095 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZBZFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:55:23 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: Miklos Szeredi <miklos@szeredi.hu>, tomas@slax.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8219.1235627470@jrobl>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl> <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu> <8219.1235627470@jrobl>
Date: Thu, 26 Feb 2009 14:55:09 +0900
Message-ID: <8248.1235627709@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I tested it on linux-2.6.28.

J. R. Okajima

> Miklos Szeredi:
> > The simplest version is with all branches read-only.  That gets rid of
> > a _huge_ amount of complexity, yet it's still useful in some
> > situations.  It also deals with a lot of the basic infrastucture
> > needed for stacking.
> 
> I made it.
> Since you already pulled aufs2-2.6.git tree, please try or review
> aufs2-tmp-ro branch. Most of my local test scripts are useless for
> readnonly mount. But I picked up some and they all passed.
> 
> $ wc -l fs/aufs/*.[ch] | tail -1
>  12677 total
> 
> About 50% of lines are deleted.
