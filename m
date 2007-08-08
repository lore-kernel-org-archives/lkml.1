Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbXHHNAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbXHHNAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXHHM75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:59:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:34957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbXHHM74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:59:56 -0400
To: richard kennedy <richard@rsk.demon.co.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>
	<1186575947.3106.23.camel@castor.rsk.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Aug 2007 15:54:15 +0200
In-Reply-To: <1186575947.3106.23.camel@castor.rsk.org>
Message-ID: <p734pjarv20.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

richard kennedy <richard@rsk.demon.co.uk> writes:
> 
> This is on a standard desktop machine so there are lots of other
> processes running on it, and although there is a degree of variability
> in the numbers,they are very repeatable and your patch always out
> performs the stock mm2.
> looks good to me

iirc the goal of this is less to get better performance, but to avoid long user visible
latencies.  Of course if it's faster it's great too, but that's only secondary.

-Andi
