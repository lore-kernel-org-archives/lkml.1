Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXHDTQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXHDTQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765162AbXHDTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:16:13 -0400
Received: from lazybastard.de ([212.112.238.170]:43821 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765049AbXHDTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:16:12 -0400
Date: Sat, 4 Aug 2007 21:12:06 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070804191205.GA24723@lazybastard.org>
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46B4C0A8.1000902@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 August 2007 14:08:40 -0400, Jeff Garzik wrote:
> Linus Torvalds wrote:
> >The "relatime" thing that David mentioned might well be very useful, but 
> >it's probably even less used than "noatime" is. And sadly, I don't really 
> >see that changing (unless we were to actually change the defaults inside 
> >the kernel).
> 
> I actually vote for that.  IMO, distros should turn -on- atime updates 
> when they know its needed.

If you mean "relatime" I concur.  "noatime" hurts mutt and others while
"relatime" has no known problems, afaics.

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
