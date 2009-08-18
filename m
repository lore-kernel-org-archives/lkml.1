Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbZHRMAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbZHRMAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbZHRMAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:00:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40435 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZHRMAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:00:11 -0400
To: jens.axboe@oracle.com
CC: w@1wt.eu, miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20090818085051.GM12579@kernel.dk> (message from Jens Axboe on
	Tue, 18 Aug 2009 10:50:51 +0200)
Subject: Re: [PATCH] splice: update mtime and atime on files
References: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu> <20090815064241.GE12579@kernel.dk> <20090818050027.GE11624@1wt.eu> <20090818083547.GK12579@kernel.dk> <20090818084625.GF18709@1wt.eu> <20090818085051.GM12579@kernel.dk>
Message-Id: <E1MdNM6-0003y3-4t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Aug 2009 13:59:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Jens Axboe wrote:
> I've never heard anyone complain about this, and I suspect that Miklos
> found it from code inspection rather than experiencing an issue with it.

Right, I found it by code inspection.

> So while it can indeed be classified as a bug (and it is), the impact is
> not huge.
> 
> That said, I don't have a huge issue with shoving this in -stable. I
> just don't think it's a big deal.

I agree that it's not a huge issue, however it might be worth it to
add it to -stable for the sake of distro kernels which are usually
based on the long term stable branch.  If new apps start to use the
splice interface then we want those to work well on distros as well as
the latest kernel.org kernels.

Thanks,
Miklos
