Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbXHCMiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbXHCMiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbXHCMh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:37:57 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4713 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXHCMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:37:56 -0400
Message-ID: <46B32197.8090708@shadowen.org>
Date: Fri, 03 Aug 2007 13:37:43 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53B70.1010903@intel.com> <Pine.LNX.4.64.0707241852510.18990@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707241852510.18990@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 23 2007 16:36, Kok, Auke wrote:
>> this somehow seems to match something completely non-related (a function
>> pointer declaration case):
>>
>> ERROR: no space between function name and open parenthesis '('
>> #7278: FILE: drivers/net/e1000e/hw.h:434:
>> +       bool (*check_mng_mode)(struct e1000_hw *);
>>
>> even if I put a space between ")(", it still complains.
> 
> [assumed] majority of kernel code uses ")(" instead of ")\s+(",
> so the warning seems bogus. And it even gets nitpicky.

No that is just a false positive.  Those are meant to be detected, its
just that bool wasn't listed as a type.

-apw
