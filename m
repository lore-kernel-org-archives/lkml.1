Return-Path: <linux-kernel-owner+w=401wt.eu-S1766710AbXDEQAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766710AbXDEQAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767116AbXDEQAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:00:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29881 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766710AbXDEQAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:00:02 -0400
Message-ID: <46151D41.50801@oracle.com>
Date: Thu, 05 Apr 2007 09:01:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] doc/kernel-parameters: use IA-32 tag instead of i386
References: <20070404220534.36cd24e9.randy.dunlap@oracle.com>	<20070404224152.29062e47.akpm@linux-foundation.org>	<20070405084155.e00687a4.randy.dunlap@oracle.com> <20070405164935.607adfc6@the-village.bc.nu>
In-Reply-To: <20070405164935.607adfc6@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Alan wrote:
>> | NAK. IA-32 is an Intel specific term, and I believe a protected mark at
>> | that.
>>
>> OMG, quick, please send a patch for Documentation/kernel-parameters.txt.
>> (big ;)
> 
> 
> Its a lot simpler to use sed. Can't find IA32 as a mark, seems the Itanic
> one was but not that. X86-32 is more consistent and not Intel specific so
> one search and waste later (plus a line move)

Yep, thanks, looks good to me.  However, you say "Can't find IA32 as a mark",
but it's used in a couple of places that should also be changed:

	code_bytes	[IA32] How many bytes of object code to print in an
			oops report.
			Range: 0 - 8192
			Default: 64

and

	disable_8254_timer
	enable_8254_timer
			[IA32/X86_64] Disable/Enable interrupt 0 timer routing
			over the 8254 in addition to over the IO-APIC. The
			kernel tries to set a sensible default.


> Signed-off-by: Alan Cox <alan@redhat.com> [not that a mechanistic conversion has any rights associated with it]
> 
> --- Documentation/kernel-parameters.txt~	2007-04-05 16:30:30.817515360 +0100
> +++ Documentation/kernel-parameters.txt	2007-04-05 16:30:30.824514296 +0100
> @@ -41,7 +41,6 @@
>  	EIDE	EIDE/ATAPI support is enabled.
>  	FB	The frame buffer device is enabled.
>  	HW	Appropriate hardware is enabled.
> -	IA-32	IA-32 aka i386 architecture is enabled.
>  	IA-64	IA-64 architecture is enabled.
>  	IOSCHED	More than one I/O scheduler is enabled.
>  	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
> @@ -91,6 +90,7 @@
>  	VT	Virtual terminal support is enabled.
>  	WDT	Watchdog support is enabled.
>  	XT	IBM PC/XT MFM hard disk support is enabled.
> +	X86-32	X86-32, aka i386 architecture is enabled.
>  	X86-64	X86-64 architecture is enabled.
>  			More X86-64 boot options can be found in
>  			Documentation/x86_64/boot-options.txt .


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
