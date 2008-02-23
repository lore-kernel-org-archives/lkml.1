Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbYBWMR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbYBWMR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYBWMRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:17:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:7222 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYBWMRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:17:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nrXxrSkX1iNt5LqaHTLwv+7JOu0Xp443vMDvYXWekx6cvzZ6bxyh6SHVppMAureAB1GAgnqso5XvEdMWaxfNzOIAMsJ/D067gd/47ZiD+L21CNFoQx8nGrEfESWVRR0HPCOuHwQMHiffDSIhBdqnXwMca7MUvHUMJS/RdpFbMyU=
Message-ID: <f19298770802230417w53b73b4ci24484d8bf0f7db9a@mail.gmail.com>
Date: Sat, 23 Feb 2008 15:17:20 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Michael Buesch" <mb@bu3sch.de>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linville@tuxdriver.com, davem@sunset.davemloft.net
In-Reply-To: <Pine.LNX.4.64.0802231353440.27587@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <47BF101F.30301@protei.ru>
	 <200802221848.37902.mb@bu3sch.de> <20080223110751.GN23833@elte.hu>
	 <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
	 <20080223112436.GA31304@elte.hu>
	 <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
	 <84144f020802230337s35c72b50wf8b892777bff42a2@mail.gmail.com>
	 <f19298770802230351i7a1bdba8pcb1faf4af9b7d385@mail.gmail.com>
	 <Pine.LNX.4.64.0802231353440.27587@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 2:57 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Alexey,
>
>
>  On Sat, Feb 23, 2008 at 2:37 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
> > >  So does reverting commit 753f492093da7a40141bfe083073400f518f4c68
>  > >  ("[B44]: port to native ssb support") fix the regression?
>  > >
>
>
> On Sat, 23 Feb 2008, Alexey Zaytsev wrote:
>  > Compiling it right now.
>  >
>  > I'm sure it fixes the problem, but I don't feel like we should revert
>  > it. I can't
>  > be sure it won't cause any other problems, and anyway, this does not look
>  > right a solution. Any other driver (rightfully) requiring the SSB_HOST would
>  > then also break the bcm43xx driver.
>  >
>  > I'll send an simplified patch in a few minutes.
>
>  The point here is that it's Michael's patch and I don't want to start
>  blaming anyone until you've verified it actually broke your setup. And if
>  the problem was actually caused by that patch, Michael needs to either ACK
>  your patch or fix it himself.

Yes, the problem was caused by this patch. With it reverted, I've got
both ethernet
and wifi working.

>
>                         Pekka
>
