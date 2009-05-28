Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZE1Lxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZE1Lxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbZE1LxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:53:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:34289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZE1LxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:53:24 -0400
Subject: Re: [PATCH-tip] x86: apic/io_apic.c dmar_msi_type should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, x86 maintainers <x86@kernel.org>,
       Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1242252753.3364.22.camel@localhost.localdomain>
References: <1242252753.3364.22.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 28 May 2009 17:22:21 +0530
Message-Id: <1243511541.3669.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

If you want please also add this patch along with another dmar_msi_type
static patch.

Thanks,
--
JSR

On Thu, 2009-05-14 at 03:42 +0530, Jaswinder Singh Rajput wrote:
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 0a3f3ab..f3e16ad 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3538,7 +3538,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
>  
>  #endif /* CONFIG_SMP */
>  
> -struct irq_chip dmar_msi_type = {
> +static struct irq_chip dmar_msi_type = {
>  	.name = "DMAR_MSI",
>  	.unmask = dmar_msi_unmask,
>  	.mask = dmar_msi_mask,

