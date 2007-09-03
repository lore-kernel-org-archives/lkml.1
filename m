Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbXICOtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbXICOtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 10:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbXICOtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 10:49:05 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:8977 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbXICOtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 10:49:04 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Mon, 3 Sep 2007 16:48:42 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070903144842.GK7916@erda.amd.com>
References: <20070830174311.221133000@amd.com>
 <200709031215.03473.ak@suse.de> <20070903112746.GH7916@erda.amd.com>
 <200709031448.42285.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200709031448.42285.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 03 Sep 2007 14:48:43.0128 (UTC)
 FILETIME=[85F45F80:01C7EE39]
X-WSS-ID: 6AC2C1470X86422949-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On 03.09.07 14:48:41, Andi Kleen wrote:

> > As said above, I do not see CF8 access as a workaround. I expect my
> > system to work in the same way also if MMCONFIG is not available.
>
> It should boot sure, but exotic stuff not working is not a major issue

It is not only about booting the system without MMCONFIG, it is also
about using the system. For this PCI ECS CF8 access is needed. So why
not adding support for this? Excluding major parts of CPU registers
when using CF8 base access only will cause writing code to workaround
this. Not very nice to handle.

-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com


