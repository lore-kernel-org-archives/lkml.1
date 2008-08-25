Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYHYG1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYHYG1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYHYG1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:27:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44518 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751622AbYHYG1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:27:45 -0400
Date: Mon, 25 Aug 2008 15:27:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh64: re-add the __strnlen_user() prototype
Message-ID: <20080825062734.GA19834@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080822152029.GA26762@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822152029.GA26762@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 06:20:29PM +0300, Adrian Bunk wrote:
> Commit 42fd3b142d8867f5b58d6fb75592cd20fd654c1b
> (sh: Initial consolidation of the _32/_64 uaccess split.)
> mistakenly removed the sh64 __strnlen_user() prototype,
> resulting in the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      init/main.o
> In file included from include/linux/poll.h:13,
>                  from include/linux/rtc.h:113,
>                  from include/linux/efi.h:19,
>                  from init/main.c:43:
> arch/sh/include/asm/uaccess.h: In function 'strnlen_user':
> arch/sh/include/asm/uaccess.h:213: error: implicit declaration of function '__strnlen_user'
> ...
> make[2]: *** [init/main.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Applied, thanks.
