Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYFLTvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYFLTvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbYFLTvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:51:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:17075 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYFLTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oTSn+JV6xXodLHU61wFJtEIGMeLsIHP3K/fr9RUcx+DejX5BZnf6aRFHq1hBH9MmOz
         g4Q30yBonS7lrrzrB24O1304B6SOZkf2EMZ9GMrHn76utASoWZpQRVTAiF0wFn2/4CWf
         K9QllHb/kLS1P7VorBr3ErG8oMtsx04MMdI9Y=
Message-ID: <86802c440806121251v6470df17sf0dabb1b24c0851e@mail.gmail.com>
Date: Thu, 12 Jun 2008 12:51:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 1/2] x86/pci: Renaming k8-bus_64.c to amd_bus.c
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <1213294763-19566-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080603072550.GR23679@erda.amd.com>
	 <1213294763-19566-1-git-send-email-robert.richter@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:19 AM, Robert Richter <robert.richter@amd.com> wrote:
> The name fits better since this is code not only for K8.
>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/pci/Makefile_64 |    2 +-
>  arch/x86/pci/amd_bus.c   |  528 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/pci/k8-bus_64.c |  528 ----------------------------------------------
>  3 files changed, 529 insertions(+), 529 deletions(-)
>  create mode 100644 arch/x86/pci/amd_bus.c
>  delete mode 100644 arch/x86/pci/k8-bus_64.c
>
> diff --git a/arch/x86/pci/Makefile_64 b/arch/x86/pci/Makefile_64
> index 8fbd198..fd47068 100644
> --- a/arch/x86/pci/Makefile_64
> +++ b/arch/x86/pci/Makefile_64
> @@ -13,5 +13,5 @@ obj-y                 += legacy.o irq.o common.o early.o
>  # mmconfig has a 64bit special
>  obj-$(CONFIG_PCI_MMCONFIG) += mmconfig_64.o direct.o mmconfig-shared.o
>
> -obj-y          += k8-bus_64.o
> +obj-y          += amd_bus.o

can we keep the _64?

It is used by 64bit only at this time.

YH
