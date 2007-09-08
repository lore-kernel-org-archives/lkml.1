Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbXIHHFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbXIHHFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXIHHFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:05:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33502 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbXIHHFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:05:15 -0400
Date: Sat, 8 Sep 2007 09:05:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: akpm@osdl.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: [patch] Fix BIOS-e820 end address
In-Reply-To: <20070908205044.GA16419@askeshav-devel.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0709080904480.25942@fbirervta.pbzchgretzou.qr>
References: <20070908205044.GA16419@askeshav-devel.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 8 2007 13:50, Keshavamurthy, Anil S wrote:
>--snip of boot message--
>BIOS-provided physical RAM map:
> BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 000000007fe8cc00 (usable)
>----end snip---
>
>As you see from above the address 0000000000100000 is both
>shown as reserved and usable which is confusing.
>
>This patch fixes the BIOS-e820 end address.

If a segment should have size 0 (even possible?), your
patch makes it even more confusing.


	Jan
-- 
