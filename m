Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbZC0LGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbZC0LGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZC0LF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:05:57 -0400
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:38054 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751488AbZC0LF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:05:56 -0400
Message-ID: <49CCB30E.3060407@teltonika.lt>
Date: Fri, 27 Mar 2009 13:05:50 +0200
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] Add documentation for "nohlt" kernel parameter
References: <20090306163558.11873.5076.stgit@Programuotojas>
In-Reply-To: <20090306163558.11873.5076.stgit@Programuotojas>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulius Zaleckas wrote:
> As per discussion in:
> http://marc.info/?l=linux-arm-kernel&m=123633652517391&w=2
> 
> v2:
> - usefull<->useful
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> ---
> 
>  Documentation/kernel-parameters.txt |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 54f21a5..5d251ad 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1487,7 +1487,9 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
>  
> -	nohlt		[BUGS=ARM,SH]
> +	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
> +			wfi(ARM) instruction doesn't work correctly and not to
> +			use it. This is also useful when using JTAG debugger.
>  
>  	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
>  			instruction doesn't work correctly and not to

Can I get your ACK on this?
I already have: Acked-by: Paul Mundt <lethal@linux-sh.org>
