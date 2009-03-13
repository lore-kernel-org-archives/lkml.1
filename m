Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZCMGxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZCMGxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 02:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZCMGxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 02:53:30 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:54555 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751625AbZCMGx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 02:53:29 -0400
Message-ID: <49BA02E4.3080208@snapgear.com>
Date: Fri, 13 Mar 2009 16:53:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
References: <200903120437.03837.rob@landley.net>	 <20090312095854.GA9398@uranus.ravnborg.org>	 <200903121503.37195.rob@landley.net>	 <20090312210216.GB14205@uranus.ravnborg.org> <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com>
In-Reply-To: <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Geert Uytterhoeven wrote:
> On Thu, Mar 12, 2009 at 22:02, Sam Ravnborg <sam@ravnborg.org> wrote:
>>> And, yes, I can confirm the m68k include/asm/unistd.h from linux-next actually
>>> has contents, thanks to commit 646652bded41f4c3bd375b4e03a25b42da93f40b
>>>
>>> Anyway, here's hoping the fix makes it into 2.6.29.
>> Why not telling the m68k maintainer that you think it should go into 2.6.29?
>>
>> As it stand now we will ikely see another mail from you "I already said so"
>> when we ship it broken but you did not care to tell relevant people.
>>
>> grep -C 5 -i m68k MAINTAINES revelas this:
>> M68K ARCHITECTURE
>> P:      Geert Uytterhoeven
>> M:      geert@linux-m68k.org
>> P:      Roman Zippel
>> M:      zippel@linux-m68k.org
>> L:      linux-m68k@lists.linux-m68k.org
>> W:      http://www.linux-m68k.org/
>> W:      http://linux-m68k-cvs.ubb.ca/
>> S:      Maintained
>>
>>
>>        Sam
>>
> 
> There are a few more:
> 
> param.h:#include "param_no.h"
> param.h:#include "param_mm.h"
> ptrace.h:#include "ptrace_no.h"
> ptrace.h:#include "ptrace_mm.h"
> setup.h:#include "setup_no.h"
> setup.h:#include "setup_mm.h"
> sigcontext.h:#include "sigcontext_no.h"
> sigcontext.h:#include "sigcontext_mm.h"
> siginfo.h:#include "siginfo_no.h"
> siginfo.h:#include "siginfo_mm.h"
> signal.h:#include "signal_no.h"
> signal.h:#include "signal_mm.h"
> swab.h:#include "swab_no.h"
> swab.h:#include "swab_mm.h"
> 
> Rob, do these also causes problems?
> Some (not all) of them are fixed in linux-next.

My patches in linux-next (from the m68knommu git tree) should
fix all but sigconext and signal in that list.

Both of those are relatively easy to fix up. I'll do that.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
