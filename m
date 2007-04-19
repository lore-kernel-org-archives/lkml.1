Return-Path: <linux-kernel-owner+w=401wt.eu-S1766895AbXDSRp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766895AbXDSRp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766902AbXDSRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:45:56 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:34361 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766895AbXDSRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:45:55 -0400
To: a.p.zijlstra@chello.nl
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
In-reply-to: <20070417071703.710381113@chello.nl> (message from Peter Zijlstra
	on Tue, 17 Apr 2007 09:10:55 +0200)
Subject: Re: [PATCH 09/12] mm: count unstable pages per BDI
References: <20070417071046.318415445@chello.nl> <20070417071703.710381113@chello.nl>
Message-Id: <E1Heafy-0006ia-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 19 Apr 2007 19:44:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Count per BDI unstable pages.
> 

I'm wondering, is it really worth having this category separate from
per BDI brity pages?

With the exception of the export to sysfs, always the sum of unstable
+ dirty is used.

Miklos
