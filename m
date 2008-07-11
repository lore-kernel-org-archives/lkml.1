Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYGKMDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYGKMDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYGKMDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:03:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33172 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYGKMDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:03:17 -0400
Date: Fri, 11 Jul 2008 14:04:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: Removing pci-y in Makefile
Message-ID: <20080711120405.GA23423@uranus.ravnborg.org>
References: <1215771239-27725-1-git-send-email-robert.richter@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215771239-27725-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 12:13:59PM +0200, Robert Richter wrote:
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/pci/Makefile |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
> index e515e8d..28451f4 100644
> --- a/arch/x86/pci/Makefile
> +++ b/arch/x86/pci/Makefile
> @@ -5,13 +5,13 @@ obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o mmconfig-shared.o
>  obj-$(CONFIG_PCI_DIRECT)	+= direct.o
>  obj-$(CONFIG_PCI_OLPC)		+= olpc.o
>  
> -pci-y				:= fixup.o
> -pci-$(CONFIG_ACPI)		+= acpi.o
> -pci-y				+= legacy.o irq.o
> +obj-y				+= fixup.o

Hi Robert.
Now I see the full patch I understood your comment.
I had missed that there was assignments above fixup.o

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam

