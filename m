Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbXLFUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbXLFUyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXLFUyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:54:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60057 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbXLFUyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:54:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] old debugging hacks sneaked back
Date: Thu, 6 Dec 2007 22:12:47 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
References: <20071206085040.GA1642@elf.ucw.cz>
In-Reply-To: <20071206085040.GA1642@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062212.48209.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of December 2007, Pavel Machek wrote:
> 
> Old debugging hack sneaked back during x86 merge, this removes it.

Yeah, good catch, thanks.

> Signed-off-by: Pavel Machek <pavel@suse.cz>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
> index a97313b..1e931aa 100644
> --- a/arch/x86/kernel/acpi/wakeup_32.S
> +++ b/arch/x86/kernel/acpi/wakeup_32.S
> @@ -35,10 +35,6 @@ wakeup_code:
>  	wakeup_code_start = .
>  	.code16
>  
> - 	movw	$0xb800, %ax
> -	movw	%ax,%fs
> -	movw	$0x0e00 + 'L', %fs:(0x10)
> -
>  	cli
>  	cld
