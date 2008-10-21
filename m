Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYJUUno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYJUUno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYJUUng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:43:36 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:35265 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYJUUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:43:35 -0400
Date: Tue, 21 Oct 2008 15:43:14 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH v2] add MODULE_ALIAS to load ipmi_devintf with ipmi_si
In-reply-to: <20081021161536.D7CD65A15E@sepang.rtg.net>
To: Tim Gardner <timg@tpi.com>
Cc: kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
       openipmi-developer@lists.sourceforge.net, scott@canonical.com
Message-id: <48FE3EE2.6040009@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20081021161536.D7CD65A15E@sepang.rtg.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this is certainly a good idea.  I'm not 100% sure of the string, 
but it looks reasonable.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

Tim Gardner wrote:
> From 07463c240c3609c1e2fbed45f64acd5fd061ce58 Mon Sep 17 00:00:00 2001
> From: Scott James Remnant <scott@canonical.com>
> Date: Tue, 21 Oct 2008 15:18:36 +0100
> Subject: [PATCH v2] add MODULE_ALIAS to load ipmi_devintf with ipmi_si
>
> The ipmi_devintf module contains the userspace interface for IPMI
> devices, yet will not be loaded automatically with a system
> interface handler driver.
>
> Add a MODULE_ALIAS for the "platform:ipmi_si" MODALIAS exported by
> the ipmi_si driver, so that userspace knows of the recommendation.
>
> Seems like a candidate for stable kernel updates.
>
> Cc: stable@kernel.org
> Signed-off-by: Scott James Remnant <scott@ubuntu.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/char/ipmi/ipmi_devintf.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
> index 64e1c16..ecaf369 100644
> --- a/drivers/char/ipmi/ipmi_devintf.c
> +++ b/drivers/char/ipmi/ipmi_devintf.c
> @@ -957,3 +957,4 @@ module_exit(cleanup_ipmi);
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
>  MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
> +MODULE_ALIAS("platform:ipmi_si");
>   

