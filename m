Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbXJKXQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbXJKXQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 19:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXJKXQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 19:16:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXJKXQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 19:16:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Leun <ml@newton.leun.net>
Subject: Re: solved: 2.6.23 && fglrx && s2ram
Date: Fri, 12 Oct 2007 01:31:17 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071012000722.3cbf17b6@elektra.leun.net>
In-Reply-To: <20071012000722.3cbf17b6@elektra.leun.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120131.17897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, 12 October 2007 00:07, Michael Leun wrote:
> Hello,
> 
> (please, don't blame me for using the binary only driver, I will
> happily switch to a open source one once it properly runs mplayer,
> e.g.).
> 
> Renaming the config options for suspend/sleep broke fglrx power
> management.

It looks like your patch is against the fglrx driver, isn't it?

> --- firegl_public.h.orig	2007-10-11 23:43:26.000000000 +0200
> +++ firegl_public.h	2007-10-11 23:53:08.000000000 +0200
> @@ -172,7 +172,7 @@
>  #endif
>  
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> -#if !defined(CONFIG_SMP) || defined(CONFIG_SUSPEND_SMP) // ACPI not working on older SMP kernel (prior to 2.6.13) 
> +#if !defined(CONFIG_SMP) || defined(CONFIG_PM_SLEEP_SMP) // ACPI not working on older SMP kernel (prior to 2.6.13) 
>  #define FIREGL_POWER_MANAGEMENT
>  #endif
>  #endif
>  
> 

Greetings,
Rafael
