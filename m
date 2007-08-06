Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbXHFIxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbXHFIxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 04:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbXHFIw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 04:52:58 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:51845 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbXHFIw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 04:52:57 -0400
Message-ID: <46B6E166.6090507@free.fr>
Date: Mon, 06 Aug 2007 10:52:54 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: PROFILE_NMI kernel config symbol
References: <46B1D26E.2010508@free.fr>
In-Reply-To: <46B1D26E.2010508@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> The -rt patch includes the following update:
> 
> Index: linux/arch/i386/oprofile/Kconfig
> ===================================================================
> --- linux.orig/arch/i386/oprofile/Kconfig
> +++ linux/arch/i386/oprofile/Kconfig
> @@ -15,3 +15,6 @@ config OPROFILE
> 
>        If unsure, say N.
> 
> +config PROFILE_NMI
> +    bool
> +    default y
> 
> 
> What is the purpose of the PROFILE_NMI config symbol?
> (It does not seem to be used anywhere else in the -rt patch.)

Should I provide a patch removing this configuration option?
