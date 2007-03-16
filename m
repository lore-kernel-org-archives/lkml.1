Return-Path: <linux-kernel-owner+w=401wt.eu-S965930AbXCPVA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965930AbXCPVA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965934AbXCPVA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:00:28 -0400
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:43396 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965933AbXCPVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:00:20 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 08:13:31 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703170040.48316.kernel@kolivas.org> <1174059299.7886.25.camel@Homer.simpson.net>
In-Reply-To: <1174059299.7886.25.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170813.32594.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 02:34, Mike Galbraith wrote:
> On Sat, 2007-03-17 at 00:40 +1100, Con Kolivas wrote:
> > Here are full patches for rsdl 0.31 for various base kernels. A full
> > announce with a fresh -mm series will follow...
> >
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3-rsdl-0.31.patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> >31.patch
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.31
> >.patch
>
> It still has trouble with the x/gforce vs two niced encoders scenario.
> The previously reported choppiness is still present.
>
> I suspect that x/gforce landing in the expired array is the trouble, and
> that this will never be smooth without some kind of exemption.  I added
> some targeted unfairness to .30, and it didn't help much at all.
>
> Priorities going all the way to 1 were a surprise.

It wasn't going to change that case without renicing X. I said that from the 
start to maintain fairness it's the only way to keep a fair design, and give 
more cpu to X. The major difference in this one is the ability to run 
different nice values without killing the latency of the relatively niced 
ones.

-- 
-ck
