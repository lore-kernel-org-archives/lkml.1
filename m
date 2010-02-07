Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0BGAy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 19:54:59 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:51553 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab0BGAy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 19:54:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y6RUpxP7AcHyD2mxahxy+odxE0lApGOOWWDcxHanTKbWsmSIha00qwGTBaV66mpvBj
         ekJYNd2w8E9w48TzdA8s6aQH2b2RFAQf1zm00A7Erj6eDNbbwhBHv/FFvovrtkt5Rtsc
         MGfA+OvQ5YHvqAEAV46tLq6A5tiPEvk9WCbUg=
MIME-Version: 1.0
In-Reply-To: <1265478443-31072-1-git-send-email-elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
	 <1265478443-31072-1-git-send-email-elendil@planet.nl>
Date: Sat, 6 Feb 2010 19:54:56 -0500
Message-ID: <b4198de61002061654t4278d789xaa7655060eef0cae@mail.gmail.com>
Subject: Re: [PATCH 01/16] alpha: remove trailing spaces in messages
From: Matt Turner <mattst88@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 6, 2010 at 12:47 PM, Frans Pop <elendil@planet.nl> wrote:
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/kernel/sys_dp264.c |    2 +-
>  arch/alpha/kernel/sys_titan.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
> index d64e1e4..4026502 100644
> --- a/arch/alpha/kernel/sys_dp264.c
> +++ b/arch/alpha/kernel/sys_dp264.c
> @@ -224,7 +224,7 @@ static void
>  dp264_device_interrupt(unsigned long vector)
>  {
>  #if 1
> -       printk("dp264_device_interrupt: NOT IMPLEMENTED YET!! \n");
> +       printk("dp264_device_interrupt: NOT IMPLEMENTED YET!!\n");
>  #else
>        unsigned long pld;
>        unsigned int i;
> diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
> index 2880533..9008d0f 100644
> --- a/arch/alpha/kernel/sys_titan.c
> +++ b/arch/alpha/kernel/sys_titan.c
> @@ -171,7 +171,7 @@ titan_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
>  static void
>  titan_device_interrupt(unsigned long vector)
>  {
> -       printk("titan_device_interrupt: NOT IMPLEMENTED YET!! \n");
> +       printk("titan_device_interrupt: NOT IMPLEMENTED YET!!\n");
>  }
>
>  static void
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-alpha" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks. I'll apply this to my tree.

Matt
