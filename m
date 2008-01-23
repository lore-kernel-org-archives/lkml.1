Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYAXGtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYAXGtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYAXGtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:49:22 -0500
Received: from babylon.websiteactive.com ([61.14.187.155]:60421 "EHLO
	babylon.websiteactive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYAXGtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:49:21 -0500
X-Greylist: delayed 26189 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 01:49:21 EST
Message-ID: <4797CE96.3060702@niasdigital.com>
Date: Thu, 24 Jan 2008 10:32:38 +1100
From: Ben Nizette <bn@niasdigital.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] fix variable use in AVR32 pte_alloc_one
References: <47972BAE.70902@niasdigital.com> <20080123132010.266eccb8@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080123132010.266eccb8@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - babylon.websiteactive.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - niasdigital.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> 
> Hmm...I can't see anything like this on my current avr32-arch branch,
> but I think I mistakenly pushed out some unfinished code about a week
> ago and rewound it shortly afterwards. If Andrew pulled during that
> window, I guess it must have made it into -mm :-(
> 
> But thanks for testing and for providing a fix. I'll check the code
> that I was working on and apply the patch if it's still broken.
> 

Cool, np.  FWIW I'm trying to get -mm to fly on AVR32 so I have access 
to the latest gpiolib stuff.  Despite this patch and "[PATCH -mm] define 
empty unxlate_dev_mem_ptr on AVR32" the build still fails due to some 
timerfd syscall horkenation.  Shall look in to that this arvo too.

> Haavard
> --

--Ben.
