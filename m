Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbYFSP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbYFSP7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYFSP7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:59:32 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:16044 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYFSP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:59:31 -0400
X-BigFish: VPS-40(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87i62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K2PWEQ-01-ZRO-01
Date: Thu, 19 Jun 2008 17:59:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: stephane eranian <eranian@googlemail.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] x86: add PCI extended config space access for AMD
	Barcelona
Message-ID: <20080619155918.GD10019@erda.amd.com>
References: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com> <1213890640-4444-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1213890640-4444-2-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Jun 2008 15:59:19.0259 (UTC) FILETIME=[6EAE2AB0:01C8D225]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.06.08 17:50:40, Robert Richter wrote:
> This patch implements PCI extended configuration space access for
> AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
> addresses. An x86 capability bit has been introduced that is set for
> CPUs supporting PCI extended config space accesses.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/cpu.h |    3 +
>  arch/x86/pci/Makefile_32  |    1 +
>  arch/x86/pci/Makefile_64  |    2 +-
>  arch/x86/pci/amd_bus.c    |  560 +++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/pci/direct.c     |   25 ++-
>  arch/x86/pci/k8-bus_64.c  |  528 ------------------------------------------
>  arch/x86/pci/pci.h        |    1 +
>  7 files changed, 584 insertions(+), 536 deletions(-)
>  create mode 100644 arch/x86/pci/amd_bus.c
>  delete mode 100644 arch/x86/pci/k8-bus_64.c

These patches are for the perfmon/master tree. They are based upon
tip/x86/cpu.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

