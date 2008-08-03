Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYHCECR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYHCECR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 00:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYHCECD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 00:02:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51360 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYHCECB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 00:02:01 -0400
Message-ID: <48952DB3.20101@zytor.com>
Date: Sat, 02 Aug 2008 21:01:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] x86: Coding style fixes to arch/x86/kernel/bios_uv.c
References: <20080802212406.047e8ae6@paolo-desktop>
In-Reply-To: <20080802212406.047e8ae6@paolo-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi wrote:
> 
> diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
> index c639bd5..100e759 100644
> --- a/arch/x86/kernel/bios_uv.c
> +++ b/arch/x86/kernel/bios_uv.c
> @@ -25,11 +25,21 @@ x86_bios_strerror(long status)
>  {
>  	const char *str;
>  	switch (status) {
> -	case  0: str = "Call completed without error"; break;
> -	case -1: str = "Not implemented"; break;
> -	case -2: str = "Invalid argument"; break;
> -	case -3: str = "Call completed with error"; break;
> -	default: str = "Unknown BIOS status code"; break;
> +	case  0:
> +		str = "Call completed without error";
> +		break;
> +	case -1:
> +		str = "Not implemented";
> +		break;
> +	case -2:
> +		str = "Invalid argument";
> +		break;
> +	case -3:
> +		str = "Call completed with error";
> +		break;
> +	default:
> +		str = "Unknown BIOS status code";
> +		break;
>  	}
>  	return str;
>  }

This should be an array in the first place...

	-hpa
