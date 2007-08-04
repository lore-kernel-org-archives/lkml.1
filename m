Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbXHDTa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbXHDTa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765425AbXHDTaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:30:19 -0400
Received: from lazybastard.de ([212.112.238.170]:44186 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765178AbXHDTaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:30:17 -0400
Date: Sat, 4 Aug 2007 21:26:15 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070804192615.GA25600@lazybastard.org>
References: <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070804192130.GA25346@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 August 2007 21:21:30 +0200, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> 
> > > I actually vote for that.  IMO, distros should turn -on- atime 
> > > updates when they know its needed.
> > 
> > If you mean "relatime" I concur.  "noatime" hurts mutt and others 
> > while "relatime" has no known problems, afaics.
> 
> so ... one app can keep 30,000+ apps hostage?
> 
> i use Mutt myself, on such a filesystem:
> 
>    /dev/md0 on / type ext3 (rw,noatime,nodiratime,user_xattr)
> 
> and i can see no problems, it notices new mails just fine.

Given the choice between only "atime" and "noatime" I'd agree with you.
Heck, I use it myself.  But "relatime" seems to combine the best of both
worlds.  It currently just suffers from mount not supporting it in any
relevant distro.

Jörn

-- 
Joern's library part 2:
http://www.art.net/~hopkins/Don/unix-haters/tirix/embarrassing-memo.html
