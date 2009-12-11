Return-Path: <linux-kernel-owner+w=401wt.eu-S933831AbZLKW1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831AbZLKW1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933446AbZLKW1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:27:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:59942 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762897AbZLKW1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:27:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J+wzDNDTWIOzanWHP4Vk89BSxkfvOpX9zAHZ/moYzZr6fVxSAQF7H3ypIR14Pxq50Y
         ai2xpGHQNqm5tgkDvd56THgaEodiLOQhYov5sRtb6qJu/7cl6DxvkaJM0X03R/sovM+3
         cf1nEHT/UA1V18N6Q46YxeVFEbemYqKzcnsWs=
Date: Sat, 12 Dec 2009 01:27:04 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH] x86: Remove 4095 enabling x2apic messages
Message-ID: <20091211222704.GD5777@lenovo>
References: <4B226E92.5080904@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B226E92.5080904@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 08:08:50AM -0800, Mike Travis wrote:
> x86: Remove 4095 enabling x2apic messages
>
> Print only once that the system is supporting x2apic mode.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> arch/x86/kernel/apic/apic.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux.orig/arch/x86/kernel/apic/apic.c
> +++ linux/arch/x86/kernel/apic/apic.c
> @@ -1358,7 +1358,7 @@
>
> 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
> 	if (!(msr & X2APIC_ENABLE)) {
> -		pr_info("Enabling x2apic\n");
> +		printk_once(KERN_INFO "Enabling x2apic\n");
> 		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
> 	}
> }
>

FWIW, looks good to me,
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

thanks!

	-- Cyrill
