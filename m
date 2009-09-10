Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZIJFia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZIJFia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZIJFi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:38:29 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:42461 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752821AbZIJFi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:38:28 -0400
Message-ID: <4AA890B5.8000207@snapgear.com>
Date: Thu, 10 Sep 2009 15:37:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: m86k/m68knommu tree build failure
References: <20090910151137.fb71c103.sfr@canb.auug.org.au>
In-Reply-To: <20090910151137.fb71c103.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell wrote:
> Today's linux-next build (m68k defconfig) failed like this:
> 
> kernel/built-in.o: In function `ptrace_resume':
> ptrace.c:(.text+0xc5d6): undefined reference to `user_disable_single_step'
> ptrace.c:(.text+0xc5fe): undefined reference to `user_enable_single_step'
> ptrace.c:(.text+0xc620): undefined reference to `user_disable_single_step'
> 
> Caused by commit 5db612ef70d24be12f6dbf5d06b23bcd6bc2fc05 ("m68knommu:
> define arch_has_single_step() and friends").  This commit added
> definitions of these functions for m68knommu, but added declarations (and
> arch_has_single_step()) in a common header file.

Ah, yes, thanks. I'll fix that. I don't regularly build for m68k,
so I missed that in my test builds.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
