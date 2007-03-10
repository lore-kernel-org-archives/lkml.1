Return-Path: <linux-kernel-owner+w=401wt.eu-S1767732AbXCJCxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767732AbXCJCxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 21:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767733AbXCJCxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 21:53:39 -0500
Received: from mail30.syd.optusnet.com.au ([211.29.133.193]:33983 "EHLO
	mail30.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767732AbXCJCxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 21:53:38 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 13:53:16 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703101320.23125.kernel@kolivas.org> <20070310022656.GQ10394@waste.org>
In-Reply-To: <20070310022656.GQ10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101353.17030.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 13:26, Matt Mackall wrote:
> On Sat, Mar 10, 2007 at 01:20:22PM +1100, Con Kolivas wrote:
> > Progress at last! And without any patches! Well those look very
> > reasonable to me. Especially since -j5 is a worst case scenario.
>
> Well that's with a noyield patch and your sched_tick fix.
>
> > But would you say it's still _adequate_ with ccache considering you
> > only have 1/6th cpu left for X? With and without ccache it's quite a
> > different workload so they will behave differently.
>
> No, I don't think 1/6th is being left for X in the ccache case so I
> think there's a bug lurking here. My memload, execload, and forkload
> test cases did better even with X niced.
>
> To confirm, I've just run 15 instances of memload with unniced Xorg
> and it performs better than make -j 5 with ccache.
>
> If I have some time tomorrow, I'll try to do a straight -mm1 to mm2
> comparison with different loads.

Great, thanks very much for all that. I've found a few subtle bugs in the 
process and some that haven't made it to the list either. I'll respin a set 
of patches against -mm2 with the changes shortly.

Thanks!

-- 
-ck
