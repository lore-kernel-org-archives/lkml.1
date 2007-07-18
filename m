Return-Path: <linux-kernel-owner+w=401wt.eu-S935095AbXGRQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095AbXGRQ6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761110AbXGRQ55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:57:57 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37776 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761746AbXGRQ5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:57:55 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <469E4791.5040806@am.sony.com>
Date: Wed, 18 Jul 2007 10:02:09 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Lindsay Roberts <lindsay.roberts.os@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
Subject: Re: [PATCH] fs: Add romfs version 2
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>	 <20070717013635.d6d0b124.akpm@linux-foundation.org>	 <20070717192100.GE11166@waste.org> <8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com>
In-Reply-To: <8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2007 16:57:49.0634 (UTC) FILETIME=[C5D12220:01C7C95C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lindsay Roberts wrote:
> Yes, my experience has been that it has been almost chillingly close
> to .5k per regular file increase in partition size. I know in
> applications in which size is utterly critical this may be slightly
> unattractive, but in cases where romfs is chosen for its byte
> reproducibility and read-only nature the size/performance tradeoff is
> fairly advantageous.

The size increase makes this a complete non-starter in the
embedded configs I'm familiar with.  Size is still the number
one problem using Linux in consumer electronics products.

I have nothing against this patch, if it achieve some speedups
for other environments.  But I wouldn't expect to see this
option used much in embedded devices.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

