Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbZEKChh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbZEKChh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbZEKChF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:37:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:34016 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757533AbZEKChD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:37:03 -0400
Date: Mon, 11 May 2009 11:36:07 +0900
To: jirislaby@gmail.com
Cc: mingo@elte.hu, yanghy@cn.fujitsu.com, akpm@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dma-mapping: mark DMA_nBITS_MASK as deprecated fix
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241939066-10178-1-git-send-email-jirislaby@gmail.com>
References: <20090510085618D.fujita.tomonori@lab.ntt.co.jp>
	<1241939066-10178-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090511113659U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 11:36:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 09:04:26 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Andrew, please fold into
> dma-mapping: mark DMA_nBITS_MASK as deprecated
> --
> 
> As Fujita correctly demurs, use more meaningful typedef name, so that we
> now see:
> warning: DMA_nnBIT_MASK is deprecated
> instead of
> warning: DMA_DEPRECATED is deprecated
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/dma-mapping.h |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


But I think that you need to resend a version of this patch against
tip. We need this patch in linux-next to warn some new users of these
deprecated macros.

Thanks,
