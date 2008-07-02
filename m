Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYGBXjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYGBXjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYGBXi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:38:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:9819 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYGBXi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nUfu9zOEheBjn8RlixjQY0shO4HRtH5I1oDIFabnLoyUoBdfWnZpfjs8Cup4Hzv9ty
         omuPPYZntjMQxKDsjGbKqHwV4Dr7qczn2fjVEoO+uLiqJkMwYMNaKJrRXTTjDPMYelR0
         R57iCGFCGFK1ns/iCOStez/j3WxN1Q/OL1q1c=
Message-ID: <86802c440807021638v7787800fkca21744e02b37df0@mail.gmail.com>
Date: Wed, 2 Jul 2008 16:38:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 04/11] x86/pci: Makefile merge: Decoupling options for mp_bus_to_node.o
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1215031829-29124-5-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
	 <1215031829-29124-5-git-send-email-robert.richter@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 1:50 PM, Robert Richter <robert.richter@amd.com> wrote:
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/pci/Makefile |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
> index 8491894..d69a0fe 100644
> --- a/arch/x86/pci/Makefile
> +++ b/arch/x86/pci/Makefile
> @@ -14,14 +14,12 @@ pci-y                               := fixup.o
>  # legacy/irq.o
>  pci-$(CONFIG_ACPI)             += acpi.o
>  pci-y                          += legacy.o irq.o
> +pci-$(CONFIG_NUMA)             += mp_bus_to_node.o
>
>  # Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
>  # therefor correct. This needs a proper fix by distangling the code.
>  pci-$(CONFIG_X86_VISWS)                := visws.o fixup.o
> -pci-$(CONFIG_X86_NUMAQ)                := numa.o irq.o

looks like you didn't base on latest tip/master...

YH
