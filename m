Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbYF3KpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbYF3KpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYF3KpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:45:00 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:58045 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYF3KpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:45:00 -0400
X-BigFish: VPS-19(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K39V6K-01-8K5-01
Date: Mon, 30 Jun 2008 12:44:44 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jeff Garzik <jeff@garzik.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add PCI IDs for AMD Barcelona PCI devices
Message-ID: <20080630104444.GA24467@erda.amd.com>
References: <20080627140905.EBD1C83D4@erda.amd.com> <4865666A.9040306@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4865666A.9040306@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 30 Jun 2008 10:44:46.0141 (UTC) FILETIME=[4FF826D0:01C8DA9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.06.08 18:15:06, Jeff Garzik wrote:
> Robert Richter wrote:
>> +#define PCI_DEVICE_ID_AMD_10H_NB_HT	0x1200
>> +#define PCI_DEVICE_ID_AMD_10H_NB_MAP	0x1201
>> +#define PCI_DEVICE_ID_AMD_10H_NB_DRAM	0x1202
>> +#define PCI_DEVICE_ID_AMD_10H_NB_MISC	0x1203
>> +#define PCI_DEVICE_ID_AMD_10H_NB_LINK	0x1204
>>  #define PCI_DEVICE_ID_AMD_LANCE		0x2000
>>  #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
>
> Are these constants going to be used in future kernels?
>
> We don't necessarily want to create constants for each PCI ID in existence. 
>  A more comprehensive database is kept at http://pciids.sourceforge.net/

All constants will be used. There are already hardcoded values that
will be replaced in follow on patches.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

