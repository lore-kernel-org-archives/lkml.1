Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZDULGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZDULGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 07:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZDULGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 07:06:32 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57941 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752754AbZDULGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 07:06:31 -0400
Message-ID: <49EDA8B4.1090808@snapgear.com>
Date: Tue, 21 Apr 2009 21:06:28 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: michal.simek@petalogix.com
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Microblaze noMMU/MMU merge
References: <49ED79AB.10004@petalogix.com>
In-Reply-To: <49ED79AB.10004@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Michal Simek wrote:
> I would like to say your opinion about putting together Microblaze MMU
> arch to noMMU version.
> 
> In C code will be #ifdef CONFIG_MMU ... #endif  or #ifndef.
> 
> Here is proposal for headers. The similar style is used in m68k but I
> would like to have the same code
> for both archs in main file.
> 
> #ifndef _ASM_MICROBLAZE_PAGE_H
> #define _ASM_MICROBLAZE_PAGE_H
> 
> code for noMMU and MMU which is the same for both.
> 
> #ifdef __uClinux__
> #include "page_no.h" -> noMMU specific
> #else
> #include "page_mm.h"-> MMU specific
> #endif
> #endif /* _ASM_MICROBLAZE_PAGE_H */

Breaking up the files that way is really only temporary. They will
eventually all be merged back to single files (I have probably
reworked about 60% of them so far). There ends up being very little
difference.

I would keep single files if you could.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
