Return-Path: <linux-kernel-owner+w=401wt.eu-S932670AbYD1H0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbYD1H0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764880AbYD1H0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:26:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:46418 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbYD1H0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b8u6Mvy9+8B+Gkrl2+CvbNFexr/zfDmrczNxi2aUyD18lXEdWBuf74BS82z1HujPRUglfgC57OghZ7YnJ1kCEupEkI2t3xelV6fzCdQqFXGqM8S7GmMhamgNy2njTmNNeHkn6P7VWIxap6TiSaiUMwPXQeU8OFhXLODZJ5trCck=
Message-ID: <a8e1da0804280026s510deacfq268da0f0fc62a298@mail.gmail.com>
Date: Mon, 28 Apr 2008 15:26:31 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: dpn@isomerica.net
Subject: Re: NULL dereference OOPS on SysRq-w
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <a8e1da0804280008s38d3b16vfedb3860cd7d5222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48141EFA.6080700@isomerica.net>
	 <20080428065736.GA2714@darkstar.te-china.tietoenator.com>
	 <48157664.2060302@isomerica.net>
	 <a8e1da0804280008s38d3b16vfedb3860cd7d5222@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 3:08 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Mon, Apr 28, 2008 at 3:01 PM, Dan Noe <dpn@isomerica.net> wrote:
>  > Dave Young wrote:
>  >
>  > > [snip]
>  > >
>  > > I have a fix for the NULL pointer reference BUG, tested on my pc.
>  > > ---
>  > >
>  > > "m" will be NULL if seq_printf & seq_puts is called from sched_debug_show
>  > > Use SEQ_* macros to fix it
>  > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>  > >
>  >
>  >  There is actually already a patch out for this which simply hasn't made it
>  > upstream yet - Mike Galbraith emailed me with it and it indeed fixes the
>  > problem.  I hadn't realized his email didn't go to lkml.. otherwise I would
>  > have echoed that here to avoid wasting people's time.  My apologies.
>
>  Ok, thanks.
>
>  While debuging this issue I found another BUG about sysrq,
>
>  echo w >/proc/sys/kernel/sysrq
>  My system hangs, there's no response from then on.

Strange, the bug can not be reproduced now. Now I only get the
expected result "Invalid argument".
