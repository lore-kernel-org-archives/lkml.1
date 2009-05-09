Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZEIX47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZEIX47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 19:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZEIX4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 19:56:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:51213 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbZEIX4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 19:56:47 -0400
Date: Sun, 10 May 2009 08:55:17 +0900
To: jirislaby@gmail.com
Cc: mingo@elte.hu, yanghy@cn.fujitsu.com, akpm@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] DMA: mark DMA_nBITS_MASK as deprecated
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241769638-27301-1-git-send-email-jirislaby@gmail.com>
References: <20090507111846.GI28398@elte.hu>
	<1241769638-27301-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090510085618D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 10 May 2009 08:55:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 May 2009 10:00:38 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> > Can you see a way to emit build warnings? If yes then that might be 
> > a better solution instead of breaking in-the-pipeline code.
> 
> What about this:
> --
> 
> Mark them deprecated so that 3rd party vendors get notified about that
> before their modules break by removing those macros later.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  include/linux/dma-mapping.h |   26 ++++++++++++++------------
>  1 files changed, 14 insertions(+), 12 deletions(-)

Ah, nice magic!

Well, "warning: 'DMA_DEPRECATED' is deprecated" warning message is a
bit obscure but the developers should notice that they do something
wrong.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Thanks a lot,
