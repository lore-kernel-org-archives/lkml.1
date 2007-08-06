Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbXHFU1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbXHFU1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXHFU1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:27:10 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42081 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbXHFU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:27:09 -0400
To: a.p.zijlstra@chello.nl
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
In-reply-to: <20070803123712.987126000@chello.nl> (message from Peter Zijlstra
	on Fri, 03 Aug 2007 14:37:13 +0200)
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>
Message-Id: <E1II99f-0005mv-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Aug 2007 22:26:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Per device dirty throttling patches

Andrew, may I inquire about your plans with this?

> These patches aim to improve balance_dirty_pages() and directly address three
> issues:
>   1) inter device starvation
>   2) stacked device deadlocks

This one interests me most, due to various real life, reported
problems with fuse filesystems.  For this reason I'd really like to
get this or a subset of it into mainline as soon as possible.

This patchset (or rather the -v7 version) has been running on my
laptop for a couple of weeks without problems.  I've also verified
that it solves the fuse and loop issues.

I have some qualms about the complexity of various parts though.
Especially the "proportions" library, which I'm having problems
understanding.  I'm not sure that this level of sophistication is
really needed to solve the issues with the old code.

Miklos
