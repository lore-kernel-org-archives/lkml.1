Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbYBLBwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbYBLBwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYBLBwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:52:01 -0500
Received: from rex.snapgear.com ([203.143.235.140]:46445 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754384AbYBLBwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:52:00 -0500
Message-ID: <47B0FBBD.9060009@snapgear.com>
Date: Tue, 12 Feb 2008 11:51:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
References: <20080207125824.GB7111@infradead.org>	<20080207130117.GA18750@uranus.ravnborg.org>	<200802071609.36960.openembedded@haerwu.biz>	<20080207160557.GB28435@flint.arm.linux.org.uk>	<20080207202329.GA21949@uranus.ravnborg.org>	<1202461453.5469.217.camel@pmac.infradead.org>	<20080208094538.GC21852@flint.arm.linux.org.uk>	<1202465911.5469.240.camel@pmac.infradead.org>	<20080208102347.GD21852@flint.arm.linux.org.uk>	<1202467422.5469.245.camel@pmac.infradead.org> <20080208104535.GF21852@flint.arm.linux.org.uk>
In-Reply-To: <20080208104535.GF21852@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Russell King - ARM Linux wrote:
> On Fri, Feb 08, 2008 at 10:43:42AM +0000, David Woodhouse wrote:
>> On Fri, 2008-02-08 at 10:23 +0000, Russell King - ARM Linux wrote:
>>> That would be misleading though - !CPU_CP15_MMU does not mean we
>>> support unaligned accesses.  It means that we may have no way to
>>> support fixing up unaligned accesses.
>> Doesn't that mean you should disallow MTD (or at least 16-bit NOR flash)
>> if !CPU_CP15_MMU, then? But at the moment you allow it?
> 
> Ask Hyok or Greg Ungerer.

I would agree that it means disabling 16-bit NOR flash, but the 8-bit
case should be fine right?

A complete disable of MTD seems like overkill. A more fine grained
approach would be better.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
