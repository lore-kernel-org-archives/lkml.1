Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYFMNQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYFMNQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYFMNQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:16:29 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:8899 "EHLO
	mail75-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755735AbYFMNQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:16:27 -0400
X-Greylist: delayed 1710 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2008 09:16:27 EDT
X-BigFish: VPS-45(zz1432R98dR62a3L7efV1805M1fa4Lzz10d3izzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2EJJI-02-RCW-01
Date: Fri, 13 Jun 2008 14:47:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] x86/pci: Renaming k8-bus_64.c to amd_bus.c
Message-ID: <20080613124745.GB10019@erda.amd.com>
References: <20080603072550.GR23679@erda.amd.com> <1213294763-19566-1-git-send-email-robert.richter@amd.com> <86802c440806121251v6470df17sf0dabb1b24c0851e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806121251v6470df17sf0dabb1b24c0851e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Jun 2008 12:47:46.0902 (UTC) FILETIME=[AE392760:01C8CD53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.08 12:51:36, Yinghai Lu wrote:
> > -obj-y          += k8-bus_64.o
> > +obj-y          += amd_bus.o
> 
> can we keep the _64?
> 
> It is used by 64bit only at this time.

Patch 2/2 will introduce code that works also for 32 bit.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

