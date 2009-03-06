Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZCFQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZCFQOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZCFQOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:14:38 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:18308 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZCFQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:14:37 -0500
Message-ID: <49B14C12.5050402@oracle.com>
Date: Fri, 06 Mar 2009 08:15:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-sh@vger.kernel.org, yanok@emcraft.com, wd@denx.de
Subject: Re: [PATCH] Add documentation for "nohlt" kernel parameter
References: <20090306122925.9779.95415.stgit@Programuotojas>
In-Reply-To: <20090306122925.9779.95415.stgit@Programuotojas>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49B14BB0.0012:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulius Zaleckas wrote:
> As per discussion in:
> http://marc.info/?l=linux-arm-kernel&m=123633652517391&w=2
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> ---
> 
>  Documentation/kernel-parameters.txt |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 54f21a5..de06666 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1487,7 +1487,9 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
>  
> -	nohlt		[BUGS=ARM,SH]
> +	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
> +			wfi(ARM) instruction doesn't work correctly and not to
> +			use it. This is also usefull when using JTAG debugger.

			                     useful
>  
>  	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
>  			instruction doesn't work correctly and not to


-- 
~Randy
