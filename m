Return-Path: <linux-kernel-owner+w=401wt.eu-S1765474AbYBWMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765474AbYBWMYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYBWMYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:24:01 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:61445 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYBWMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:23:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Hyr/VTkvjLHCzXWVqfPKLzYwaUHifLeb5OzTYfjIs63v6Hk3oXXPYkkQ5b0oVdydg4Cvx13eCD0NMwMDd5oMjRm3Tb2j19T6h9FPUt2ya9CBq7PmlIEFUc315JdDV65ioiVnAbS0y9LgoC4nwCCGMon1dyqJpZoOVkDCvLM/Sq8=
Message-ID: <84144f020802230423p65d5b27bw2edd8d0aad9a980f@mail.gmail.com>
Date: Sat, 23 Feb 2008 14:23:58 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Michael Buesch" <mb@bu3sch.de>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linville@tuxdriver.com, davem@sunset.davemloft.net
In-Reply-To: <f19298770802230417w53b73b4ci24484d8bf0f7db9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de>
	 <20080223110751.GN23833@elte.hu>
	 <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
	 <20080223112436.GA31304@elte.hu>
	 <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
	 <84144f020802230337s35c72b50wf8b892777bff42a2@mail.gmail.com>
	 <f19298770802230351i7a1bdba8pcb1faf4af9b7d385@mail.gmail.com>
	 <Pine.LNX.4.64.0802231353440.27587@sbz-30.cs.Helsinki.FI>
	 <f19298770802230417w53b73b4ci24484d8bf0f7db9a@mail.gmail.com>
X-Google-Sender-Auth: 7aaa570f28c598e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 23, 2008 at 2:37 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > >  So does reverting commit 753f492093da7a40141bfe083073400f518f4c68
> > > >  ("[B44]: port to native ssb support") fix the regression?

On Sat, Feb 23, 2008 at 2:17 PM, Alexey Zaytsev
<alexey.zaytsev@gmail.com> wrote:
>  Yes, the problem was caused by this patch. With it reverted, I've got both ethernet
>  and wifi working.

Michael, I am always glad to help out but I would much appreciate if
you could show some effort on debugging your own bugs in the future.
Perhaps you could now work with Alexey to fix it?
