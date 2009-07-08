Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbZGHQuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbZGHQuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZGHQur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:50:47 -0400
Received: from claw.goop.org ([74.207.240.146]:37489 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZGHQuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:50:46 -0400
Message-ID: <4A54CE62.8040704@goop.org>
Date: Wed, 08 Jul 2009 09:50:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: jeremy@xensource.com, chrisw@sous-sol.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 33/44] includecheck fix: drivers/xen, evtchn.c
References: <1247063308.4382.12.camel@ht.satnam> <1247067749.4382.90.camel@ht.satnam>
In-Reply-To: <1247067749.4382.90.camel@ht.satnam>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/09 08:42, Jaswinder Singh Rajput wrote:
> fix the following 'make includecheck' warning:
>
>   drivers/xen/evtchn.c: linux/errno.h is included more than once.
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Thanks,
    J

> ---
>  drivers/xen/evtchn.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
> index af03195..79bedba 100644
> --- a/drivers/xen/evtchn.c
> +++ b/drivers/xen/evtchn.c
> @@ -38,7 +38,6 @@
>  #include <linux/string.h>
>  #include <linux/errno.h>
>  #include <linux/fs.h>
> -#include <linux/errno.h>
>  #include <linux/miscdevice.h>
>  #include <linux/major.h>
>  #include <linux/proc_fs.h>
>   

