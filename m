Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZIWVMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZIWVMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZIWVMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:12:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51065 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZIWVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:12:34 -0400
Date: Wed, 23 Sep 2009 22:12:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Subject: Re: [PATCH v4, REBASED 1/2] ARM: Pass IFSR register to
	do_PrefetchAbort()
Message-ID: <20090923211214.GA25115@n2100.arm.linux.org.uk>
References: <00ae0c0830ca659709d80e56e8e87b636c32fcf6.1253616961.git.kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00ae0c0830ca659709d80e56e8e87b636c32fcf6.1253616961.git.kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 02:00:14PM +0300, Kirill A. Shutemov wrote:
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 379f785..924ec14 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -520,7 +520,7 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  }
>  
>  asmlinkage void __exception
> -do_PrefetchAbort(unsigned long addr, struct pt_regs *regs)
> +do_PrefetchAbort(unsigned long addr, int ifsr, struct pt_regs *regs)

Almost there - this should be 'unsigned int ifsr'.

Other than that, patches are fine.
