Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbYL2PZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbYL2PZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYL2PZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:25:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:25149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYL2PZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P2QeQV/KK32wgtBvvfOnpnoAp2+ad0QzhCZxGsbodE/FMquuTbz15HFCUzmwz7O/BY
         ZgxPIFuWkK9MTsyjSXhfmanQHEm0eubbHt/rc+XiEJa5Xacu9OXXhue6q6TMyHh2Ezlh
         obcL3DqJGP2kO1MBaab27iLISzRwjUvXSvYh4=
Date: Mon, 29 Dec 2008 18:24:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: io_apic.c io_apic_sync should be static
Message-ID: <20081229152456.GA7459@localhost>
References: <1230563075.26564.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230563075.26564.4.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Mon, Dec 29, 2008 at 08:34:35PM +0530]
| Impact: cleanup, reduce kernel size a bit, avoid sparse warning
| 
| Fixes sparse warning:
| arch/x86/kernel/io_apic.c:709:6: warning: symbol 'io_apic_sync' was not declared. Should it be static?
| 
| Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| ---
|  arch/x86/kernel/io_apic.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
| 
| diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
| index 62ecfc9..6991172 100644
| --- a/arch/x86/kernel/io_apic.c
| +++ b/arch/x86/kernel/io_apic.c
| @@ -706,7 +706,7 @@ static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
|  }
|  
|  #ifdef CONFIG_X86_64
| -void io_apic_sync(struct irq_pin_list *entry)
| +static void io_apic_sync(struct irq_pin_list *entry)
|  {
|  	/*
|  	 * Synchronize the IO-APIC and the CPU by doing
| -- 
| 1.5.5.1

Thanks Jaswinder! It should be static.

		- Cyrill -
