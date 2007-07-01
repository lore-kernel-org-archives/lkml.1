Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXGAU24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXGAU24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbXGAUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46903 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757935AbXGAUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:24 -0400
Date: Sun, 1 Jul 2007 22:23:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.22-rc6-mm1: Xen: WARNING: Absolute relocations present
Message-ID: <20070701202347.GY10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070628204001.GA6087@stusta.de> <46841EC4.7080805@goop.org> <m1hcoorv79.fsf@ebiederm.dsl.xmission.com> <4687D744.6000103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4687D744.6000103@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 09:33:08AM -0700, Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>
>>   
>>> Adrian Bunk wrote:
>>>     
>>>> <--  snip  -->
>>>>
>>>> ...
>>>>   RELOCS  arch/i386/boot/compressed/vmlinux.relocs
>>>> WARNING: Absolute relocations present
>>>> Offset     Info     Type     Sym.Value Sym.Name
>>>> c0101f80 020c6501   R_386_32 00000000  xen_irq_disable_direct_reloc
>>>> c0101f9a 0221ea01   R_386_32 00000000  xen_save_fl_direct_reloc
>>>> ...
>>>>
>>>> <--  snip  -->
>>>>
>>>>       
>>> Hm.  Those are false alarms.  I guess I could do something to hide them, 
>>> but
>>> there's nothing inherently wrong with correctly used abs symbols.  Is 
>>> there
>>> someway to whitelist them?
>>>     
>>
>> Yes.  Just add them to arch/i386/boot/compressed/relocs.c safe_abs_syms.
>>   
>
> OK, how's this?
>
> Subject: xen: suppress abs symbol warnings for unused reloc pointers
>...

Thanks, works for me.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

