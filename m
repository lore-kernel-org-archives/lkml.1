Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbZGJGvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbZGJGvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZGJGvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:51:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:28243 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZGJGvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:51:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,377,1243839600"; 
   d="scan'208";a="163507845"
Date: Fri, 10 Jul 2009 14:48:31 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 07/12] SFI: add x86 support
Message-ID: <20090710144831.63b7021a@feng-desktop>
In-Reply-To: <20090710063726.GF22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
	<4676b1fee4cae65c678754fbdecae626ac161b81.1247025117.git.len.brown@intel.com>
	<20090710063726.GF22218@elte.hu>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 14:37:26 +0800
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Len Brown <lenb@kernel.org> wrote:
> 
> > From: Feng Tang <feng.tang@intel.com>
> >
> > arch/x86/kernel/sfi.c serves the dual-purpose of supporting the
> > SFI core with arch specific code, as well as a home for the
> > arch-specific code that uses SFI.
> >
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > ---
> >  arch/x86/kernel/Makefile |    1 +
> >  arch/x86/kernel/sfi.c    |  284
> > ++++++++++++++++++++++++++++++++++++++++++++++
> > drivers/sfi/sfi_core.c   |    2 +- 3 files changed, 286
> > insertions(+), 1 deletions(-) create mode 100644
> > arch/x86/kernel/sfi.c
> >
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index 6c327b8..e430123 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -53,6 +53,7 @@ obj-y                               += step.o
> >  obj-$(CONFIG_STACKTRACE)     += stacktrace.o
> >  obj-y                                += cpu/
> >  obj-y                                += acpi/
> > +obj-$(CONFIG_SFI)            += sfi.o
> >  obj-y                                += reboot.o
> >  obj-$(CONFIG_MCA)            += mca_32.o
> >  obj-$(CONFIG_X86_MSR)                += msr.o

> 
> and write those 'any match' lines as:
> 
>         sfi_table_parse(SFI_SIG_CPUS, SFI_ANY_KEY, sfi_parse_cpus);
> 
> which is _far_ more readable and more extensible as well. (it is
> trivial to extend such a design with a new key field - while with
> the current open-coded structure it's far more invasive to do such a
> change.)
>  
> Thanks,
> 
>         Ingo

Thanks again for the great comments to this v2 series, will address them soon.

Thanks,
Feng
