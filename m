Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZLGGmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZLGGmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZLGGmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:42:36 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:50385 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753747AbZLGGmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:42:36 -0500
Message-ID: <4B1CA3E3.7000603@snapgear.com>
Date: Mon, 07 Dec 2009 16:42:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Maxim Kuvyrkov <maxim@codesourcery.com>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: M68k tree updates
References: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>	 <4B13CC00.9080607@codesourcery.com> <10f740e80912041157j41984f4ay6ca2e56d70ac08e2@mail.gmail.com>
In-Reply-To: <10f740e80912041157j41984f4ay6ca2e56d70ac08e2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Mon, Nov 30, 2009 at 14:43, Maxim Kuvyrkov <maxim@codesourcery.com> wrote:
>> Geert Uytterhoeven wrote:
>>> It took me a while, but finally I managed to update
>>> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git again.
>> ...
>>> If anything is missing, please tell me. Thx!
>> How about the NPTL patch (0001-Add-NPTL-support-for-m68k.patch,
>> http://marc.info/?l=linux-m68k&m=125447760017098&w=2)?
> 
> As you're adding syscalls (which are shared with m68knommu), I'll have
> to ask whether
> you will make it work on nommu, too?
> 
> Furthermore, when building for Sun3:
> 
> arch/m68k/kernel/sys_m68k.c:706: warning: passing argument 1 of
> 'kunmap' from incompatible pointer type
> arch/m68k/kernel/sys_m68k.c:714: warning: passing argument 1 of
> 'kunmap' from incompatible pointer type
> 
> Which looks like a problem with the Sun 3 version of pte_unmap().
> 
> I'm gonna add it to the m68k tree though, unless someone complains.
> 
>> Also, this trivial fix (0004-Fix-m68k-s-asm-swab.h-for-ColdFire.patch,
>> http://marc.info/?l=linux-m68k&m=125447494213740&w=2) can go in.
> 
> I want to run this one by the nommu people as well...

That patch looks good to me.

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
