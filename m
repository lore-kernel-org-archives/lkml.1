Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXIMUTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXIMUTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765683AbXIMUTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:19:17 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:57502 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765459AbXIMUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:19:15 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Thu, 13 Sep 2007 22:15:59 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Andi Kleen" <ak@suse.de>,
       "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Martin Mares" <mj@ucw.cz>,
       "dean gaudet" <dean@arctic.org>,
       "Robert Richter" <robert.richter@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case
 MMCONFIG is used
Message-ID: <20070913201559.GB1131@alberich.amd.com>
References: <200709121921.43950.yinghai.lu@sun.com>
 <200709131147.43446.ak@suse.de> <20070913104704.GA3878@kroah.com>
 <200709131353.15752.ak@suse.de>
 <86802c440709131001w4b758921r52a23f1732a6e9c8@mail.gmail.com>
 <46E97178.2040903@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46E97178.2040903@zytor.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 13 Sep 2007 20:16:03.0118 (UTC)
 FILETIME=[E86E84E0:01C7F642]
X-WSS-ID: 6AF7452F1A47520834-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 10:20:56AM -0700, H. Peter Anvin wrote:
> Yinghai Lu wrote:
> > 
> > BIOS guys also said that fam 10h need mmconfig via eax accessing, may
> > need OS do sth, so it is safe to stay with MCFG entry for SB like
> > mcp55...
> > 
> > but latest kernel already have that workaround to make mmconfig via eax...
> > 
> 
> This is actually a good point.  Since the CPU vendor managed to
> completely fuck up the operation of MMCONFIG itself on this CPU (it's a
> *MEMORY REFERENCE*, guys!), it is actually to be expected and prudent
> that BIOS vendors will drop the MCFG entry.  MMCONFIG doesn't actually
> work on this CPU for any system software which doesn't already know to
> work around this particular piece of severe braindamage;

But wait, isn't it true that Vista is using MCFG?
So, poor BIOS guys what should they do now?
If you have a special problem here why not upgrading your Linux kernel?

> standards-complicant MMCONFIG isn't supported at all.

And yes, it is complicated to follow your argumentation.


Andreas



