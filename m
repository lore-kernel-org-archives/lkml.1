Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZKTOGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZKTOGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZKTOGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:06:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:55964 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZKTOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:06:31 -0500
Message-ID: <4B06A268.203@windriver.com>
Date: Fri, 20 Nov 2009 08:06:32 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix section mismatch in early ehci dbgp
References: <4B06ACCD02000078000211E0@vpn.id2.novell.com>
In-Reply-To: <4B06ACCD02000078000211E0@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2009 14:06:32.0455 (UTC) FILETIME=[A9BE1170:01CA69EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Commit 917778267fbe67703ab7d5c6f0b7a05d4c3df485 removed __init from
> ehci_wait_for_port(), but left it in place on ehci_reset_port(), which
> is being called from the former function.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jason Wessel <jason.wessel@windriver.com>
>   

Acked-by: Jason Wessel <jason.wessel@windriver.com>

> ---
>  drivers/usb/early/ehci-dbgp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.32-rc8/drivers/usb/early/ehci-dbgp.c	2009-11-20 14:11:29.000000000 +0100
> +++ 2.6.32-rc8-ehci-dbgp-section-mismatch/drivers/usb/early/ehci-dbgp.c	2009-11-20 11:23:52.000000000 +0100
> @@ -613,7 +613,7 @@ err:
>  }
>  EXPORT_SYMBOL_GPL(dbgp_external_startup);
>  
> -static int __init ehci_reset_port(int port)
> +static int ehci_reset_port(int port)
>  {
>  	u32 portsc;
>  	u32 delay_time, delay;
>
>
>
>   

