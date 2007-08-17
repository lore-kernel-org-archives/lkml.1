Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXHQCMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXHQCMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXHQCMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:12:40 -0400
Received: from waste.org ([66.93.16.53]:43386 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbXHQCMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:12:40 -0400
Date: Thu, 16 Aug 2007 21:13:47 -0500
From: Matt Mackall <mpm@selenic.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, John Berthels <jjberthels@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] maps: PSS(proportional set size) accounting in smaps
Message-ID: <20070817021346.GH30556@waste.org>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.064901548@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816220849.064901548@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 06:05:17AM +0800, Fengguang Wu wrote:
> The "proportional set size" (PSS) of a process is the count of pages it has in
> memory, where each page is divided by the number of processes sharing it. So if
> a process has 1000 pages all to itself, and 1000 shared with one other process,
> its PSS will be 1500.
>                - lwn.net: "ELC: How much memory are applications really using?"
> 
> The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
> memory footprint. So collect and export it via /proc/<pid>/smaps.
> 
> Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job.
> They are comprehensive tools. But for PSS, let's do it in the simple way. 

It's a bit odd that you attribute the description of PSS to LWN rather
than me. But anyway:

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
