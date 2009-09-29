Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZI2Rab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZI2Rab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZI2Raa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:30:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZI2Raa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:30:30 -0400
Message-ID: <4AC24396.4080402@zytor.com>
Date: Tue, 29 Sep 2009 10:27:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: akataria@vmware.com
CC: Chris Wright <chrisw@sous-sol.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>	 <20090919224430.GB9567@kroah.com>	 <1253419185.3253.21.camel@ank32.eng.vmware.com>	 <20090920074247.GA5733@elte.hu>	 <1253647845.10565.20.camel@ank32.eng.vmware.com>	 <4AB9CE66.1030504@redhat.com>	 <1254185107.13456.32.camel@ank32.eng.vmware.com>	 <4AC17018.4040600@zytor.com>	 <1254193238.13456.48.camel@ank32.eng.vmware.com>	 <20090929090130.GD3958@sequoia.sous-sol.org> <1254245124.7803.34.camel@ank32.eng.vmware.com>
In-Reply-To: <1254245124.7803.34.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 10:25 AM, Alok Kataria wrote:
> diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
> index 31e6f6c..d430e4c 100644
> --- a/arch/x86/kernel/vmi_32.c
> +++ b/arch/x86/kernel/vmi_32.c
> @@ -648,7 +648,7 @@ static inline int __init activate_vmi(void)
>  
>  	pv_info.paravirt_enabled = 1;
>  	pv_info.kernel_rpl = kernel_cs & SEGMENT_RPL_MASK;
> -	pv_info.name = "vmi";
> +	pv_info.name = "vmi [deprecated]";
>  
>  	pv_init_ops.patch = vmi_patch;
>  
> 
> 

Where is this string used, and could this break something?

	-hpa

