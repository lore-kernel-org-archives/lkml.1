Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZFUHlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZFUHlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 03:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZFUHk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 03:40:56 -0400
Received: from mga07.intel.com ([143.182.124.22]:26546 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751399AbZFUHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 03:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,262,1243839600"; 
   d="scan'208";a="156830852"
Message-ID: <4A3DE3F3.4000100@linux.intel.com>
Date: Sun, 21 Jun 2009 00:40:35 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Martin Mares <mj@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-arch@vger.kernel.org
Subject: Re: RFC: x86: cap iomem_resource to addressable physical memory
References: <4A2F0D45.2040602@linux.intel.com> <86802c440906111343g513a2ceau1e2bfdf14c295b2d@mail.gmail.com> <4A316D3C.7080403@linux.intel.com> <20090621064201.GD1656@ucw.cz>
In-Reply-To: <20090621064201.GD1656@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2009-06-11 13:46:52, H. Peter Anvin wrote:
>> Yinghai Lu wrote:
>>> do we need do that on every cpu?
>>>
>>> looks like we could do that in identify_boot_cpu.
>>>
>> What if the CPUs are heterogenous?  It's obviously a suboptimal
>> situation, but it doesn't seem like something we can rely on.
> 
> Is it ok if that changes during runtime? What if someone hotplugs
> heterogenous cpu? I'd say basing it on boot cpu seems simplest.
> 									Pavel
> 

If someone hotplugs heterogenous CPUs it should do the right thing if 
the right thing is possible to do.  If you already have resource 
assignments that are unfulfillable you're screwed anyway.

	-hpa

