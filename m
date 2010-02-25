Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0BYGEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 01:04:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:42250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab0BYGEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 01:04:08 -0500
Message-ID: <4B86122C.10102@kernel.org>
Date: Wed, 24 Feb 2010 22:01:16 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Du, Alek" <alek.du@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86/mrst: add dependencies for Moorestown
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com> <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org> <4B8493A0.6080501@kernel.org> <4B84A846.1000805@kernel.org> <4B84AAC4.2020204@kernel.org> <4B858E89.7040807@kernel.org> <43F901BD926A4E43B106BF17856F0755A321EB54@orsmsx508.amr.corp.intel.com> <4B859DD1.601@zytor.com> <4B85A3C1.3030903@kernel.org> <4B85A8B8.3000608@zytor.com> <4B85AB6C.8000500@kernel.org> <43F901BD926A4E43B106BF17856F0755A321EDE5@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A321EDE5@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 04:41 PM, Pan, Jacob jun wrote:
> Moorestown platform depends on IOAPIC, specify dependency correctly.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0ab2dce..b50788d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -388,8 +388,10 @@ config X86_ELAN
>  
>  config X86_MRST
>         bool "Moorestown MID platform"
> +	depends on PCI_IOAPIC
>  	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
> +	depends on X86_IO_APIC
>  	select APB_TIMER
>  	---help---
>  	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin

so mrst is
1) SMP or not?
2) if is not SMP, does it still have MADT?

YH
