Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYFMQUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYFMQUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbYFMQU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:20:29 -0400
Received: from mail-va3.bigfish.com ([216.32.180.114]:39626 "EHLO
	mail189-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757275AbYFMQU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:20:29 -0400
X-BigFish: VPS-44(zz1432R98dR4015M62a3L7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2ETDJ-01-7TM-01
Date: Fri, 13 Jun 2008 18:19:11 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] x86: Move PCI IO ECS code to x86/pci
Message-ID: <20080613161911.GF10019@erda.amd.com>
References: <20080603072550.GR23679@erda.amd.com> <1213294763-19566-2-git-send-email-robert.richter@amd.com> <86802c440806121250s1b04c553ld505f6c76c2e206@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806121250s1b04c553ld505f6c76c2e206@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Jun 2008 16:19:12.0055 (UTC) FILETIME=[3729E470:01C8CD71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.08 12:50:10, Yinghai Lu wrote:
> > +static int __init enable_pci_io_ecs(void)
> > +{
> > +       /* assume all cpus from fam10h have IO ECS */
> > +        if (boot_cpu_data.x86 < 0x10)
> > +               return 0;
> > +       on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1, 1);
> 
> how about some cpu hotplug? i mean if you limit that when booting and
> later use "echo 1 > /sys/.../online" etc to get it online.

Yinghai, will look at this.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

