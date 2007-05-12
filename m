Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbXELIWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbXELIWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXELIWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 04:22:20 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:48893 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877AbXELIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 04:22:19 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] mm: swap prefetch improvements
Date: Sat, 12 May 2007 18:21:47 +1000
User-Agent: KMail/1.9.5
Cc: nickpiggin@yahoo.com.au, ray-lk@madrabbit.org, mingo@elte.hu,
       ck@vds.kolivas.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705121728.34987.kernel@kolivas.org> <20070512011454.50ba68a5.pj@sgi.com>
In-Reply-To: <20070512011454.50ba68a5.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121821.48515.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 18:14, Paul Jackson wrote:
> > Ummm this is what I've been saying for over a year now but noone has been
> > listening.
>
> Well ... if there is a problem using prefetch and cpusets together,
> it doesn't look like the two of us are going to find it.
>
> I should probably look at your patch to answer this next question,
> but being a lazy retard, I'll just ask.  Is there a way, on a running
> system that has your prefetch patch configured in, to disable prefetch
> -- perhaps writing to some magic /proc file or something?

Indeed:

/proc/sys/vm/swap_prefetch

> If so, then how about you just remove the lines in the patch that
> disable prefetch on kernels configured with CPUSETS, and we charge
> ahead allowing both at the same time?

Ok so change the default value for swap_prefetch to 0 when CPUSETS is enabled? 
Sure, I can do that.

> If some day in the future I find something about prefetch that harms
> the HPC NUMA loads I care about, then I can just dynamically disable
> prefetch.
>
> If someone ever uncovers a real problem with prefetch and cpusets,
> then we will deal with it then.
>
> As to whether your patch is otherwise (other than cpusets) worthy
> of further acceptance, that I will have to leave up to those who are
> competent to make such judgements.

Thank you very much for your comments!

-- 
-ck
