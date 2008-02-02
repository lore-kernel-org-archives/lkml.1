Return-Path: <linux-kernel-owner+w=401wt.eu-S934271AbYBBVHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbYBBVHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759704AbYBBVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:07:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:18394 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbYBBVHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:07:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Zwr3aOEeH1SXj5vPZko2Brr0joCFtNuYD94VWYiCEU3dP2/GkuBlNzK8qJXS3OqtcaIXH8ioiV9praKdsBhCprh7hB9GB/mu7bLoRZEwLk0ew+H44zQokU6b7+nckEcjRGcdUilEYPaqnIxRAX7ZxuOHfVpageIn3w40mEdJVcg=
Message-ID: <84144f020802021307ja672fdfl29e54483e9f900d@mail.gmail.com>
Date: Sat, 2 Feb 2008 23:07:20 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ondrej Zary" <linux@rainbow-software.org>
Subject: Re: [PATCH] [RFC] 3c509: convert to isa_driver and pnp_driver v2
Cc: netdev@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <200802021925.36552.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801312012.43447.linux@rainbow-software.org>
	 <200802021925.36552.linux@rainbow-software.org>
X-Google-Sender-Auth: 42aebde97b8bfe37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 2, 2008 8:25 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> +//static __be16 el3_phys_addr[EL3_MAX_CARDS][3];

[snip]

> +//#if defined(CONFIG_MCA) || defined(CONFIG_EISA)

[snip]

> +//     while (el3_probe(el3_cards) == 0) {
> +//             if (irq[el3_cards] > 1)
> +//                     el3_root_dev->irq = irq[el3_cards];
> +//             if (xcvr[el3_cards] >= 0)
> +//                     el3_root_dev->if_port = xcvr[el3_cards];
> +//             el3_cards++;
> +//     }

You might want to consider dropping these hunks...
