Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYI2Xwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYI2Xwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYI2XwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:52:25 -0400
Received: from gw.goop.org ([64.81.55.164]:43347 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYI2XwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:52:25 -0400
Message-ID: <48E16A2E.10603@goop.org>
Date: Mon, 29 Sep 2008 16:52:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN
References: <20080929182423.268c4283@redhat.com>
In-Reply-To: <20080929182423.268c4283@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> From: Chuck Ebbert <cebbert@redhat.com>
>
> xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN
>
> Xen options need to depend on XEN.
> Also, add newline at end of file.
>
> Without this patch you need to disable CONFIG_PM in order to
> disable CPU hotplugging.
>
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
>
> Index: linux-2.6.26.noarch/arch/x86/xen/Kconfig
> ===================================================================
> --- linux-2.6.26.noarch.orig/arch/x86/xen/Kconfig
> +++ linux-2.6.26.noarch/arch/x86/xen/Kconfig
> @@ -26,5 +26,5 @@ config XEN_MAX_DOMAIN_MEMORY
>  
>  config XEN_SAVE_RESTORE
>         bool
> -       depends on PM
> -       default y
> \ No newline at end of file
> +       depends on XEN && PM
> +       default y
>   

