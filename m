Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZFXPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZFXPmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZFXPmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:42:03 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:39427 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZFXPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:42:02 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A42494E.80308@lwfinger.net>
Date: Wed, 24 Jun 2009 10:42:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain> <4A423686.8050905@lwfinger.net> <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Thomas Gleixner wrote:
> Larry,
> 
> 
> can you please the patch below instead of the other one ?
> 
> Thanks,
> 
> 	tglx
> ---
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 16c3fda..39a0cce 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -99,7 +99,6 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
>  			"%d resource descriptors\n", (unsigned long) res->start,
>  			(unsigned long) res->end, root->name, info->name,
>  			max_root_bus_resources);
> -		info->res_num++;
>  		return AE_OK;
>  	}

Sorry, this patch does not fix the problem.

Larry
