Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZEKGdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZEKGdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZEKGdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:33:31 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:47484 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbZEKGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:33:31 -0400
Message-ID: <4A07C6B9.7090504@snapgear.com>
Date: Mon, 11 May 2009 16:33:29 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH 0/2] section name cleanup for m68knommu
References: <1241135412-8636-1-git-send-email-tabbott@mit.edu>
In-Reply-To: <1241135412-8636-1-git-send-email-tabbott@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> This patch series cleans up the section names on the m68knommu
> architecture.  It requires the architecture-independent macro
> definitions from this patch series:
> 
> <http://www.spinics.net/lists/mips/msg33499.html>
> 
> The long-term goal here is to add support for building the kernel with
> -ffunction-sections -fdata-sections.  This requires renaming all the
> magic section names in the kernel of the form .text.foo, .data.foo,
> .bss.foo, and .rodata.foo to not have collisions with sections
> generated for code like:
> 
> static int nosave = 0; /* -fdata-sections places in .data.nosave */
> static void head(); /* -ffunction-sections places in .text.head */
> 
> Note that these patches have not been boot-tested (aside from testing
> the analogous changes on x86), since I don't have access to the
> appropriate hardware.
> 
> 	-Tim Abbott
> 
> 
> Tim Abbott (2):
>   m68knommu: use new macro for .data.cacheline_aligned section.
>   m68knommu: use new macros for .data.init_task.
> 
>  arch/m68knommu/kernel/init_task.c   |    3 +--
>  arch/m68knommu/kernel/vmlinux.lds.S |    6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)

I don't see any problems here for m68knommu.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
