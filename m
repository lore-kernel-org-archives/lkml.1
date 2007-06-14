Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXFNTqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXFNTqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbXFNTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:44:50 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:2889 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbXFNTot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:44:49 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 15:44:48 EDT
Message-ID: <4671992D.7060400@macroscoop.nl>
Date: Thu, 14 Jun 2007 21:38:21 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706071530.51552.jesse.barnes@intel.com>
In-Reply-To: <200706071530.51552.jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for this patch. I was having the exact same symptoms as Justin 
Piszcz, on a different, but similar motherboard:

Motherboard: GigaByte GA-G33-DS3R
BIOS rev: F2
Chipset: Intel G33
Memory: 8GB
Distro: Fedora 7 x86_64
Kernel: kernel-2.6.21-1.3194.fc7

Building vanilla 2.6.22-rc4 with your patch solved the problem.

I'm now seeing this in the syslog

  ***************
  **** WARNING: likely BIOS bug
  **** MTRRs don't cover all of memory, trimmed 196608 pages
  ***************

leaving me 7416672 kB of usable memory.

If there's any way I can help with more info or testing,
then let me know.

Thanks,
Pim

