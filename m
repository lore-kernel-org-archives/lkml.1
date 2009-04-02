Return-Path: <linux-kernel-owner+w=401wt.eu-S935687AbZDBLGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935687AbZDBLGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934729AbZDBLFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:05:54 -0400
Received: from smtp.movial.fi ([62.236.91.34]:40403 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579AbZDBLFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:05:53 -0400
Message-ID: <49D49C0F.3000707@movial.com>
Date: Thu, 02 Apr 2009 14:05:51 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: strange code in include/linux/kernel_stat.h
References: <49CCA5DF.6040804@movial.com>
In-Reply-To: <49CCA5DF.6040804@movial.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev wrote:
> Hi,
> 
> Depending on whether the CONFIG_GENERIC_HARDIRQS option is enabled or not, the header file include/linux/kernel_stat.h defines the following two entities:
> 
> - the macro kstat_irqs_this_cpu for the case when CONFIG_GENERIC_HARDIRQS is set:
> 
> #define kstat_irqs_this_cpu(DESC) \
>         ((DESC)->kstat_irqs[smp_processor_id()])
> 
> - another macro with the same name as the macro above but for the case CONFIG_GENERIC_HARDIRQS is not set:
> 
> #define kstat_irqs_this_cpu(irq) \
>         (kstat_this_cpu.irqs[irq])
> 
> Apparently, it is assumed that the types for the macro argument are different, and depend on the value of CONFIG_GENERIC_HARDIRQS. Is this intentional?
> 

I still would like to know what's going on there. Anyone knowledgeable out there, please?

Dmitri 

> Thanks,
> Dmitri
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

