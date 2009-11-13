Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZKMG1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZKMG1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 01:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZKMG1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:27:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:56329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZKMG1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:27:37 -0500
Message-ID: <4AFCFC0D.4030002@kernel.org>
Date: Thu, 12 Nov 2009 22:26:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 2/2] pci: pciehp update the slot bridge res to get big
 range for pcie devices - v10
References: <4ADEB601.8020200@kernel.org>	<4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org>	<4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com>
In-Reply-To: <4AFCF7D8.1090207@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
> Yinghai Lu wrote:
>> Kenji Kaneshige wrote:
>>> Can I ask which is the latest version?
>>>
>>> I think -v10 is the latest. But I could not find -v10 for patch 1/2.
>>
>> please use
>>
>> http://patchwork.kernel.org/patch/57814/  1/2 -v9
>> http://patchwork.kernel.org/patch/58294/  2/2 -v10
>>
> 
> Regardless of PCIe hotplug, some of PCIe devices (not on hotplug
> slots) doesn't work with your patches by the following error.
> 
> Copyright (c) 2007-2009 Intel Corporation.
> igb 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> igb 0000:07:00.0: setting latency timer to 64
> igb 0000:07:00.0: PCI INT A disabled
> igb: probe of 0000:07:00.0 failed with error -5
> igb 0000:07:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> igb 0000:07:00.1: setting latency timer to 64
> igb 0000:07:00.1: PCI INT B disabled
> igb: probe of 0000:07:00.1 failed with error -5
> igb 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> igb 0000:08:00.0: setting latency timer to 64
> igb 0000:08:00.0: PCI INT A disabled
> igb: probe of 0000:08:00.0 failed with error -5
> igb 0000:08:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
> igb 0000:08:00.1: setting latency timer to 64
> igb 0000:08:00.1: PCI INT B disabled
> igb: probe of 0000:08:00.1 failed with error -5
> 
> I'm using Jesse's latest linux-next.
> I'm attaching the /proc/iomem outputs. The iomem-default.txt is
> /proc/iomem output without your patches. The iomem-yinghai.txt
> is /proc/iomem output with your patches.

can you post whole bootlog with pci debug enabled?

Thanks

Yinghai
