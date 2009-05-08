Return-Path: <linux-kernel-owner+w=401wt.eu-S1763668AbZEHVGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763668AbZEHVGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbZEHVFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:05:30 -0400
Received: from gw.goop.org ([64.81.55.164]:39164 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbZEHVF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:05:28 -0400
Message-ID: <4A049E95.6040805@goop.org>
Date: Fri, 08 May 2009 14:05:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <20090508111024.GD11596@elte.hu> <20090508124436.GT8112@parisc-linux.org> <4A048C11.1050702@kernel.org>
In-Reply-To: <4A048C11.1050702@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 1. pcibios_set_cache_line_size looks could be __init
>   

Will double-check.

> 2. pci_xen_init and some xen_ function all for domU aka pv? that naming looks confusing.
>   

No, both dom0 and domU kernels are running PV.  The PCI stuff can be 
used in either case; dom0 for talking to devices as normal, and domU for 
PCI-passthrough.

Thanks,
    J
