Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbZD2NT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbZD2NT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbZD2NP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:15:59 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:38975 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758810AbZD2NP6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:15:58 -0400
From: Edward Goggin <egoggin@vmware.com>
To: "'Ingo Molnar'" <mingo@elte.hu>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Apr 2009 06:15:47 -0700
Subject: RE: Simple typo in reboot.c when enabling CONFIG_KDB_KDUMP
Thread-Topic: Simple typo in reboot.c when enabling CONFIG_KDB_KDUMP
Thread-Index: AcnIi/8Ite+941dwTQWrnUv94zzyLAAQHwdA
Message-ID: <B1FD1A0C73AC4E46A4F95BADC77079D35F55F115@PA-EXMBX02.vmware.com>
References: <B1FD1A0C73AC4E46A4F95BADC77079D35F55F114@PA-EXMBX02.vmware.com>
 <20090429053233.GB4103@elte.hu>
In-Reply-To: <20090429053233.GB4103@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point.  Its after applying a KDB patch from SGI.  I'll submit
the patch to Keith Owens at SGI intead. 

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu] 
> Sent: Wednesday, April 29, 2009 1:33 AM
> To: Edward Goggin
> Cc: 'linux-kernel@vger.kernel.org'
> Subject: Re: Simple typo in reboot.c when enabling CONFIG_KDB_KDUMP
> 
> 
> * Edward Goggin <egoggin@vmware.com> wrote:
> 
> > Patch 1 of 1
> > 
> > Simple typo when enabling CONFIG_KDB_KDUMP.
> > 
> > Signed-off-by: Ed Goggin <egoggin@vmware.com>
> > 
> > 
> > --- linux-2.6.29/arch/x86/kernel/reboot.c	2009-04-28 
> 14:37:30.000000000 -0400
> > +++ linux-2.6.29.fix/arch/x86/kernel/./reboot.c	
> 2009-04-28 14:37:37.000000000 -0400
> > @@ -649,7 +649,7 @@ void halt_current_cpu(struct pt_regs 
> *re  #ifdef 
> > CONFIG_X86_32
> >  	if (!user_mode_vm(regs)) {
> >  		crash_fixup_ss_esp(&fixed_regs, regs);
> > -		regs = &fixed_Regs;
> > +		regs = &fixed_regs;
> >  	}
> >  #endif
> >          crash_save_cpu(regs, raw_smp_processor_id());
> 
> There's no such code in the current upstream kernel. Exactly 
> which kernel version (sha1) are you sending a patch against?
> 
> 	Ingo
> 