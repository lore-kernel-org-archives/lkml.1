Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYIIJGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYIIJGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYIIJGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:06:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43781 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIIJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:06:11 -0400
Date: Tue, 9 Sep 2008 18:11:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, quilt-dev@nongnu.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: mmotm 2008-09-08-18-32 uploaded
Message-Id: <20080909181110.ed47df7c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080909014354.764eb9ed.akpm@linux-foundation.org>
References: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
	<20080909173753.c48a5ca7.kamezawa.hiroyu@jp.fujitsu.com>
	<20080909014354.764eb9ed.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 01:43:54 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > This stop is caused by following line in changelog.
> > 
> >     c45:608f from generic sonix sn9c103 inf file (+ ov7630 which we support)
> >     041e:4022 from creative webcam nx pro, same as already supported 041e:401e
> >     0ac8:0301 from generic zc0301 driver which supports many sensors
> >     10fd:804d from typhoon webshot driver (also FlyCAM-USB 300 plus)
> > and this line .
> >       converting those not to depend on consecutive minor numbers in commit
> >   ->  5a6411b1178baf534aa9138052864dfa89d3eada and later when dev0 was added
> > 
> > When I added a charactor in front of the number, linux-next.patch is applied.
> > Start from a number is bad ? (or my environment is bad ?)
> 
> urgh, that's patch(1) being silly and interpreting that text as part of
> a patch.  IIRC it's interpreting it as a context diff.
> 
> Adding `-u' to the `patch' command will shut it up.  That change should
> be made to quilt (IMO).  
> 
Oh, thank you.

-Kame

