Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab0BMTmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:42:44 -0500
Received: from xenotime.net ([72.52.64.118]:39936 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757104Ab0BMTmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:42:42 -0500
Message-ID: <4B7700B0.1030402@xenotime.net>
Date: Sat, 13 Feb 2010 11:42:40 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
Subject: Re: [PATCH 15/28] kgdb,docs: Update the kgdb docs to include kdb
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com> <1266014143-29444-16-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1266014143-29444-16-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/10 14:35, Jason Wessel wrote:
> Update the kgdb docs to reflect the new directory structure and API.
> 
> Merge in the kdb shell information.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---

> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index f3be1e6..af8b8e8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1102,13 +1103,17 @@ and is between 256 and 4096 characters. It is defined in the file
>  			use the HighMem zone if it exists, and the Normal
>  			zone if it does not.
>  
> -	kgdboc=		[HW] kgdb over consoles.
> +	kgdboc=		[KGDB,HW] kgdb over consoles.
>  			Requires a tty driver that supports console polling,
>  			or a supported polling keyboard driver (non-usb).
>  			Serial only format: <serial_device>[,baud]
>  			keyboard only format: kbd
>  			keyboard and serial format: kbd,<serial_device>[,baud]
>  
> +	kgdbwait	[KGDB] Stop kernel execution and enter the
> +			kernel debugger at the earliest opportunity if
> +			kgdb was configured on as a boot argument.

What does "kgdb was configured on as a boot argument" mean?

> +
>  	kmac=		[MIPS] korina ethernet MAC address.
>  			Configure the RouterBoard 532 series on-chip
>  			Ethernet adapter MAC address.


-- 
~Randy
