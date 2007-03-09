Return-Path: <linux-kernel-owner+w=401wt.eu-S2992994AbXCIG2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992994AbXCIG2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992999AbXCIG2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:28:51 -0500
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:46393 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992994AbXCIG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:28:50 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Fri, 9 Mar 2007 17:28:03 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org>
In-Reply-To: <20070309053931.GA10459@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091728.03978.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 16:39, Matt Mackall wrote:
> First off, let me say that I think your approach has great promise,
> but I'm afraid it doesn't work so well here yet.
>
> Box is an R51 Thinkpad, 1.7GHz Pentium M. I'm using a make -j 5 as a
> test load.
>
> With 2.6.21-rc2-mm2, I get slightly sluggish response for opening new
> terminals, scrolling in Galeon, and a bit jerky behaviour for spinning
> Beryl's 3D desktop. Playing MP3s off an sshfs FUSE mount works fine.
> Typing across ssh sessions has no noticeable lag. Mouse pointer
> movement is smooth.
>
> With 2.6.21-rc3-mm1, terminals take longer to open, Galeon is
> noticeably more sluggish, and Beryl's desktop switching goes from being
> jerky to a 5-second agony. Typing in shells, remote or not,
> lags noticeably. Mouse pointer is alternately smooth or jerky. But
> MP3s still work great!
>
> Problems persist with make -j 2 and make.

make -j5 sucks you'll get precisely 1/6th cpu for galeon with this scheduler 
which is perfectly fair and I make no apology for it, nor do I plan to 
optimise for it. With make (without jobs) you'll still only get 50% cpu so it 
should be precisely half speed unless you nice it. Does it feel precisely 
half speed? It's supposed to. This is one of the drawbacks of a perfectly 
fair approach; its... fair and will need more liberal use of nice.

-- 
-ck
