Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbZLOS7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbZLOS7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbZLOS7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:59:43 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53320 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZLOS7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:59:42 -0500
Date: Tue, 15 Dec 2009 19:59:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
Message-ID: <20091215185941.GO28252@kernel.dk>
References: <20091215115052.GA28252@kernel.dk> <4B277AB2.8030107@kernel.org> <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27D7E9.4030105@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Yinghai Lu wrote:
> [   13.018720] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> 
> [   13.100724] [Firmware Bug]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources

On a "normal" non-kexec boot, I get:

[   12.173583] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[   12.184075] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[   12.216874] PCI: Using configuration type 1 for base access

-- 
Jens Axboe

