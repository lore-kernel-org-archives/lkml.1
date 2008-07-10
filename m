Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYGJRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYGJRWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbYGJRWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:22:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:27132 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYGJRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J8z4nr8gHjW3RN/cmmfCOVePp032lNl7RWKfXrRTfefL6Ki5STFyYa2bWx1I4ZhJkm
         BzYEJUVydyjGviuGbY+WxWMgmgsWYuHQ5HYDMFBZSszLgi0lib6eyM4ApDddH8xEzXDm
         fWudzre47bSzXv9zc/i4eQ7fNbz5HQs0bHq4c=
Message-ID: <35f686220807101021l76446ef5wdcdb41062fcc9540@mail.gmail.com>
Date: Thu, 10 Jul 2008 10:21:57 -0700
From: "Alok kataria" <alokkataria1@gmail.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [PATCH] remove duplicate call to use_tsc_delay.
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org, akataria@vmware.com
In-Reply-To: <1215709307-13558-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215709307-13558-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My bad,

Acked-by: Alok N Kataria <akataria@vmware.com>

Thanks !!.
--
Alok

On Thu, Jul 10, 2008 at 10:01 AM, Glauber Costa <gcosta@redhat.com> wrote:
> Integration generated a duplicate call to use_tsc_delay.
> Particularly, the one that is done before we check for general
> tsc usability seems wrong.
>
> Signed-off-by: Glauber Costa <gcosta@redhat.com>
> ---
>  arch/x86/kernel/tsc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 4a775d0..3c36f92 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -513,7 +513,6 @@ void __init tsc_init(void)
>         */
>        for_each_possible_cpu(cpu)
>                set_cyc2ns_scale(cpu_khz, cpu);
> -       use_tsc_delay();
>
>        if (tsc_disabled > 0)
>                return;
> --
> 1.5.5.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
