Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZBZFvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZBZFvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZBZFva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:51:30 -0500
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:32998 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZBZFv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:51:29 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tomas@slax.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl> <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu>
Date: Thu, 26 Feb 2009 14:51:10 +0900
Message-ID: <8219.1235627470@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> The simplest version is with all branches read-only.  That gets rid of
> a _huge_ amount of complexity, yet it's still useful in some
> situations.  It also deals with a lot of the basic infrastucture
> needed for stacking.

I made it.
Since you already pulled aufs2-2.6.git tree, please try or review
aufs2-tmp-ro branch. Most of my local test scripts are useless for
readnonly mount. But I picked up some and they all passed.

$ wc -l fs/aufs/*.[ch] | tail -1
 12677 total

About 50% of lines are deleted.


J. R. Okajima
