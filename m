Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbXD3HR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbXD3HR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXD3HR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:17:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbXD3HR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:17:58 -0400
Date: Mon, 30 Apr 2007 00:17:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bradley Chapman" <kakadu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HIGHMEM4G and 1GB RAM
Message-Id: <20070430001755.e9f203c9.akpm@linux-foundation.org>
In-Reply-To: <e294b46e0704281326w60f9cecfuace3442791f147b3@mail.gmail.com>
References: <e294b46e0704281326w60f9cecfuace3442791f147b3@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 21:26:42 +0100 "Bradley Chapman" <kakadu@gmail.com> wrote:

> After installing a second 512MB SODIMM into my laptop, I noticed that
> my 2.6.18.3 kernel only detected and used 896MB of the resulting 1GB,
> and informed me that I needed to enable high memory in order to access
> the remaining 127MB.
> 
> While doing so, I noticed that the help text stated that enabling high
> memory (in my case, CONFIG_HIGHMEM4G) should only be done if the
> system the kernel is running on has more than 1GB, but less than 4GB -
> it said that systems with 1GB should leave it off, which resulted in
> an eighth of the installed memory going missing. A bit more research
> found a three year old thread on this list where it was stated that
> enabling CONFIG_HIGHMEM4G sometimes slows the system down due to
> sometimes undesirable changes to the way the kernel sets up the memory
> map.
> 
> Basically, all I want to know is whether or not enabling
> CONFIG_HIGHMEM4G for a laptop that has exactly 1GB of RAM will result
> in any performance degradation.
> 

I would expect the advantages of the additional 128MB to considerably
outweigh the cost of turning on CONFIG_HIGHMEM4G.

That cost will be a little extra CPU consumption inside the kernel, but the
great majority of CPU consumption usually happens in userspace anyway.

