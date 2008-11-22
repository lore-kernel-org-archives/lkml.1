Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYKVDaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYKVDaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYKVD3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:29:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:40040 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYKVD3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:29:43 -0500
Date: Sat, 22 Nov 2008 12:27:39 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/10] DMA-API debugging facility
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081122115802K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 17:26:00 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this patchset introduces code to debug drivers usage of the DMA-API.
> Tests with hardware IOMMUs have shown several bugs in drivers regarding
> the usage of that API.
> Problems were found especially in network card drivers.

Especially? Have you met dma similar bugs with storage (scsi, etc)
drivers?


> This way driver developers get an idea where the problem is in their
> code.
> 
> Please review and send any objections or, if there are none, consider
> for inclusion ;)

This should be architecture independent code. Except for that, it
looks very useful.

Thanks,
