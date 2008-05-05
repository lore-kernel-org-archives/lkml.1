Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYEERjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYEERjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbYEERj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:39:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51153 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYEERj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iCKx9Ifc531IwOYMYLxykOvizJE/ZXZhWACDNlXnU+k3g/wsz+i4PchoFCAOuBZv67OHMvAVRRo1eTM095bCOLpihg+Vnij6fX/4o0BLhuee7mOFtTaJ4D40HD/1x+abuKbEUElZsJe0G+NpK5rzcZ03EqyZCKNn5qK2YNY2feI=
Message-ID: <86802c440805051039i6e32e18as5b59310016ad4cc3@mail.gmail.com>
Date: Mon, 5 May 2008 10:39:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] x86: remove spew print out about bus to node mapping
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeff Garzik" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0805050905050.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041341.02375.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0805050905050.3318@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 12:06 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 4 May 2008, Yinghai Lu wrote:
>  > Jeff Garzik pointed out that is not needed. looks like spam.
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>  > diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
>  > index ab6d4b1..5c2799c 100644
>  > --- a/arch/x86/pci/k8-bus_64.c
>  > +++ b/arch/x86/pci/k8-bus_64.c
>  > @@ -504,14 +504,6 @@ static int __init early_fill_mp_bus_info(void)
>  >               }
>  >       }
>  >
>  > -#ifdef CONFIG_NUMA
>  > -     for (i = 0; i < BUS_NR; i++) {
>  > -             node = mp_bus_to_node[i];
>  > -             if (node >= 0)
>  > -                     printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
>  > -     }
>  > -#endif
>  > -
>  >       for (i = 0; i < pci_root_num; i++) {
>  >               int res_num;
>  >               int busnum;
>  >
>
>  What about this loop, looks noisy as well ?
>

  for (i = 0; i < pci_root_num; i++) {  ?

it is informative, about node/link to bus range...

YH
