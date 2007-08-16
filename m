Return-Path: <linux-kernel-owner+w=401wt.eu-S1765516AbXHPKV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765516AbXHPKV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 06:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXHPKVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 06:21:47 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:45507 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXHPKVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 06:21:46 -0400
Message-ID: <46C4248C.1090408@aitel.hist.no>
Date: Thu, 16 Aug 2007 12:18:52 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>	<20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu>	<20070804103347.GA1956@elte.hu>	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>	<20070804163733.GA31001@elte.hu> <p73hcnen7w2.fsf@bingen.suse.de>
In-Reply-To: <p73hcnen7w2.fsf@bingen.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I always thought the right solution would be to just sync atime only
> very very lazily. This means if a inode is only dirty because of an
> atime update put it on a "only write out when there is nothing to do
> or the memory is really needed" list.
>   
Seems like a good idea.  atimes will then be written only by
memory pressure - or umount.  The atimes could be wrong after
a crash, but loosing atimes only is not something
I'd worry about.

Helge Hafting
