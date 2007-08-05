Return-Path: <linux-kernel-owner+w=401wt.eu-S1761108AbXHEI56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108AbXHEI56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 04:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbXHEI5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 04:57:49 -0400
Received: from 1wt.eu ([62.212.114.60]:1146 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbXHEI5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 04:57:48 -0400
Date: Sun, 5 Aug 2007 10:53:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, J??rn Engel <joern@logfs.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805085354.GC6002@1wt.eu>
References: <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu> <20070805072141.GA4414@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805072141.GA4414@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 09:21:41AM +0200, Ingo Molnar wrote:
> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > With a Red Hat on if we can move from /dev/hda to /dev/sda in FC7 then 
> > we can move from atime to noatime by default on FC8 with appropriate 
> > release note warnings and having a couple of betas to find out what 
> > other than mutt goes boom.
> 
> btw., Mutt does not go boom, i use it myself. It works just fine and 
> notices new mails even on a noatime,nodiratime filesystem.

IIRC, atime is used by mailers and by the shell to detect that new
mail has arrived and report it only once if there are several intances
watching the same mbox.

I too use mutt and noatime,nodiratime everywhere (same 10 year-old
thinko), and the only side effect is that when I have a new mail,
it is reported in all of my xterms until I read it, clearly something
I can live with (and sometimes it's even desirable).

In fact, mutt is pretty good at this. It updates atime and ctime itself
as soon as it opens the mbox, so the shell is happy and only reports
"you have mail" afterwards.

Well, I hope we're not getting too much off-topic here...

Willy

