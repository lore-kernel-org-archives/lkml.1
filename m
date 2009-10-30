Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZJ3FC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZJ3FC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZJ3FC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:02:29 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:54964 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754144AbZJ3FC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:02:28 -0400
Message-ID: <4AEA7352.4050202@snapgear.com>
Date: Fri, 30 Oct 2009 15:02:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 1/7] m68knommu: Don't hardcode the value of PAGE_SIZE
 in the linker script.
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-1-git-send-email-tabbott@ksplice.com> <4AEA39EB.50601@snapgear.com> <alpine.DEB.1.10.0910292118390.24830@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0910292118390.24830@dr-wily.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> On Fri, 30 Oct 2009, Greg Ungerer wrote:
> 
>> Hi Tim,
>>
>> This one gives me:
>>
>> arch/m68knommu/kernel/vmlinux.lds.S:19:1: warning: "BSS" redefined
>> In file included from arch/m68knommu/kernel/vmlinux.lds.S:10:
>> include/asm-generic/vmlinux.lds.h:495:1: warning: this is the location of the
>> previous definition
>>
>> A define named "BSS" is already used inside of vmlinux.lds.S.
>> No big deal, I just changed that internal one.
>>
>> But otherwise no problems with this patch.
> 
> This actually wasn't introduced by this patch -- it was introduced when 
> the BSS macro was merged into include/asm-generic/vmlinux.lds.h in commit 
> ef53dae8658cf0e93d380983824a661067948d87.
> 
> Regardless, changing the internal one was the right fix.

Indeed. Yep. I'll commit a fix for this first.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
