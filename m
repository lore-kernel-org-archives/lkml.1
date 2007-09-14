Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXINVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXINVAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXINVAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:00:09 -0400
Received: from gw.goop.org ([64.81.55.164]:33076 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbXINVAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:00:07 -0400
Message-ID: <46EAF652.9060405@goop.org>
Date: Fri, 14 Sep 2007 14:00:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
CC: akpm@osdl.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: [patch] Fix BIOS-e820 end address
References: <20070908205044.GA16419@askeshav-devel.jf.intel.com>
In-Reply-To: <20070908205044.GA16419@askeshav-devel.jf.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keshavamurthy, Anil S wrote:
> Subject: [patch] Fix BIOS-e820 end address
>
> --snip of boot message--
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000007fe8cc00 (usable)
> ----end snip---
>
> As you see from above the address 0000000000100000 is both
> shown as reserved and usable which is confusing.
>   

I think this is consistent with many other kernel interfaces (such as
/proc/X/maps) where the end address is taken to be exclusive: [0xf0000,
0x100000).

    J
