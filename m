Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZJ1SiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZJ1SiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZJ1SiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:38:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:54625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbZJ1SiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:38:02 -0400
Message-ID: <4AE88F7B.5090505@kernel.org>
Date: Wed, 28 Oct 2009 11:37:47 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big	range
 for pcie devices
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>	 <4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>	 <4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>	 <4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>	 <4AE80170.6030402@jp.fujitsu.com>  <4AE88305.8020207@kernel.org> <1256752359.30701.12.camel@dc7800.home>
In-Reply-To: <1256752359.30701.12.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wed, 2009-10-28 at 10:44 -0700, Yinghai Lu wrote:
>>>
>> thanks, will update the patches to only handle leaf bridge, and don't touch min_size etc.
> 
> When you do, can you please add printks showing the changes you're
> making to bridge resources?  I think these events are infrequent, and
> knowing about the changes is vital to debugging problems.

sure.

[   91.762205] pci 0000:00:07.0: resource 15 [mem 0x91800000-0x91ffffff 64bit pref] released
[   91.771715] pci 0000:00:07.0: PCI bridge, secondary bus 0000:0e
[   91.783297] pci 0000:00:07.0:   IO window: 0x2000-0x2fff
[   91.791564] pci 0000:00:07.0:   MEM window: 0x90000000-0x917fffff
[   91.806376] pci 0000:00:07.0:   PREFETCH window: disabled
[   91.811537] pci 0000:40:07.0: resource 15 [mem 0xb1800000-0xb1ffffff 64bit pref] released
[   91.826760] pci 0000:40:07.0: PCI bridge, secondary bus 0000:50
[   91.841288] pci 0000:40:07.0:   IO window: 0x7000-0x7fff
[   91.847605] pci 0000:40:07.0:   MEM window: 0xb0000000-0xb17fffff
[   91.861572] pci 0000:40:07.0:   PREFETCH window: disabled
[   91.868426] pci 0000:80:07.0: resource 15 [mem 0xd1800000-0xd1ffffff 64bit pref] released
[   91.884552] pci 0000:80:07.0: PCI bridge, secondary bus 0000:90
[   91.892898] pci 0000:80:07.0:   IO window: 0xa000-0xafff
[   91.905952] pci 0000:80:07.0:   MEM window: 0xd0000000-0xd17fffff
[   91.912304] pci 0000:80:07.0:   PREFETCH window: disabled
[   91.925909] pci 0000:c0:07.0: resource 15 [mem 0xf1800000-0xf1ffffff 64bit pref] released
[   91.942305] pci 0000:c0:07.0: PCI bridge, secondary bus 0000:d0
[   91.950273] pci 0000:c0:07.0:   IO window: 0xf000-0xffff
[   91.961687] pci 0000:c0:07.0:   MEM window: 0xf0000000-0xf17fffff
[   91.969438] pci 0000:c0:07.0:   PREFETCH window: disabled

YH
