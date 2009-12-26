Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZLZTu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZLZTu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 14:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZLZTu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 14:50:58 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:40406 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZLZTu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 14:50:57 -0500
Date: Sat, 26 Dec 2009 14:50:48 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Myron Stowe <myron.stowe@hp.com>
Subject: Re: -tip: origin tree build failure
In-reply-to: <20091217075025.GA314@elte.hu>
Message-id: <alpine.LFD.2.00.0912261448100.4089@localhost.localdomain>
References: <20091217075025.GA314@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
> build failure on x86, for CONFIG_ACPI=n && CONFIG_IPMI_SI=y:
> 
>  drivers/char/ipmi/ipmi_si_intf.c:3208: error: 'ipmi_pnp_driver' undeclared (first use in this function)
...

> -#ifdef CONFIG_PNP
> +#ifdef CONFIG_ACPI
>  	pnp_register_driver(&ipmi_pnp_driver);
>  #endif
...

Hi Ingo,
As my tree inflicted this one and I don't see your patch upstream,
I'll include your fix with my "for -rc2" push.

thanks,
-Len Brown, Intel Open Source Technology Center

