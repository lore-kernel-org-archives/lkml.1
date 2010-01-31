Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612Ab0AaBrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0AaBrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 20:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397Ab0AaBrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 20:47:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36293 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0AaBrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 20:47:23 -0500
Message-ID: <4B64E0D2.3000004@zytor.com>
Date: Sat, 30 Jan 2010 17:45:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: enlightenment for ticket spinlocks
References: <4B62A39D020000780002CA80@vpn.id2.novell.com> <4B64E000.3020608@zytor.com>
In-Reply-To: <4B64E000.3020608@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2010 05:42 PM, H. Peter Anvin wrote:
> 
> + * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
> + *      of a Xen host.
> + */
> +#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
> +#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
> +#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
> 
> I hope you know this spells "MMXenVMMXenV".  The ordering is ecx-edx-ebx
> (register numbers 1, 2, 3).
> 

... and of course I got it wrong, too.  It spells "XenVnVMMMMXe".

The proper order is ebx-edx-ecx, in *reverse* numerical order.
Confusing, yes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

