Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXCPPfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXCPPfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXCPPfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:35:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:52308 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753544AbXCPPfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:35:07 -0400
X-Provags-ID: V01U2FsdGVkX19IGhRu3C1IKpz7nZxs6nVZZEoWUd3Q8fZdPHpH28
	dKQghpTudzjFuC
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703170040.48316.kernel@kolivas.org>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703141008.39516.kernel@kolivas.org>
	 <200703162325.05691.kernel@kolivas.org>
	 <200703170040.48316.kernel@kolivas.org>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 16:34:59 +0100
Message-Id: <1174059299.7886.25.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 00:40 +1100, Con Kolivas wrote:
> Here are full patches for rsdl 0.31 for various base kernels. A full announce 
> with a fresh -mm series will follow...
> 
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3-rsdl-0.31.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.31.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.31.patch
> 

It still has trouble with the x/gforce vs two niced encoders scenario.
The previously reported choppiness is still present.  

I suspect that x/gforce landing in the expired array is the trouble, and
that this will never be smooth without some kind of exemption.  I added
some targeted unfairness to .30, and it didn't help much at all.
 
Priorities going all the way to 1 were a surprise.

	-Mike

