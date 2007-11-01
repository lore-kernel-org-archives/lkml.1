Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbXKASDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbXKASDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbXKASDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:03:32 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56355 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbXKASDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:03:30 -0400
Date: Thu, 01 Nov 2007 11:06:18 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86: check boundary in count/setup_resource called by
 get_current_resources
In-reply-to: <20071101013239.992840bd.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Gary Hade <gary.hade@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <472A159A.6080106@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <200711010120.30410.yinghai.lu@sun.com>
 <20071101013239.992840bd.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 01 Nov 2007 01:20:29 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> [PATCH] x86: check boundary in count/setup_resource called by get_current_resources
>>
>> need to check info->res_num less than PCI_BUS_NUM_RESOURCES, so
>> info->bus->resource[info->res_num] = res will not beyond of bus resource array
>> when acpi resutrn too many resource entries.
>>
> 
> Isn't this a bit of a problem?  It sounds like PCI_BUS_NUM_RESOURCES is to
> small for that system?  If so, some sort of dynamic allocation might be
> needed.

sound reasonable...
i have one local patch for amd64 that will get resources from pci conf. and it will use all 8 slots for bus 0.
and transparent bus under it only can copy 5 of them.

YH
