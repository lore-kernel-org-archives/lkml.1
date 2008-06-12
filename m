Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbYFLJPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbYFLJPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYFLJPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:15:25 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:33836 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYFLJPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:15:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Date: Thu, 12 Jun 2008 11:14:53 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: vegard.nossum@gmail.com, miles.lane@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806101650.27180.mb@bu3sch.de> <200806111205.10433.mb@bu3sch.de> <20080612142235A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080612142235A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121114.54445.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 07:18:32 FUJITA Tomonori wrote:
> > Yeah ok. That's an unlikely error path.
> 
> Yeah, it doesn't always happen, but it possible that it happens?

Yes. I will create a new patch and send it to John Linville.
So it will also quickly end up in the -mm tree, too.
This will fix both bugs.

> No, seems that there are some confusion. This is just in -mm to find
> problems:
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
> 
> This patch is a trivial but changes lots of places. So it's difficult
> to get an ACK on all the places.

Thanks a lot for explaining this. This makes things a lot easier.

> This patch need several fixes but all the patches are trivial except
> for b34. I guess that it is because b34 handles devices for

It's called b43 ;)

> dma-mapping in an uncommon way.

Yeah, the hardware is pretty stupid, so we have lots of special workarounds
and so on... So I hardly touch the DMA code and was very surprised about
this bugreport. :)

-- 
Greetings Michael.
