Return-Path: <linux-kernel-owner+w=401wt.eu-S1423122AbXD3Hko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423122AbXD3Hko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423124AbXD3Hko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:40:44 -0400
Received: from holomorphy.com ([66.93.40.71]:40983 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423122AbXD3Hkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:40:43 -0400
Date: Mon, 30 Apr 2007 00:40:44 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bradley Chapman <kakadu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HIGHMEM4G and 1GB RAM
Message-ID: <20070430074044.GB19966@holomorphy.com>
References: <e294b46e0704281326w60f9cecfuace3442791f147b3@mail.gmail.com> <20070430001755.e9f203c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430001755.e9f203c9.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 21:26:42 +0100 "Bradley Chapman" <kakadu@gmail.com> wrote:
>> Basically, all I want to know is whether or not enabling
>> CONFIG_HIGHMEM4G for a laptop that has exactly 1GB of RAM will result
>> in any performance degradation.

On Mon, Apr 30, 2007 at 12:17:55AM -0700, Andrew Morton wrote:
> I would expect the advantages of the additional 128MB to considerably
> outweigh the cost of turning on CONFIG_HIGHMEM4G.
> That cost will be a little extra CPU consumption inside the kernel, but the
> great majority of CPU consumption usually happens in userspace anyway.

The CONFIG_VMSPLIT config options were merged for such cases.

It should be able to split on any 4MB-aligned boundary in
CONFIG_HIGHMEM4G. CONFIG_VMSPLIT_3G_OPT appears to do something of
this sort to use an entire 1GB RAM with minimal user address space
reduction.

This is an ELF ABI violation but the number of major applications
that break is apparently low.


-- wli
