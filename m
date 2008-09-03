Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbYICMGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbYICMGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYICMGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:06:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46800 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYICMGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:06:21 -0400
Date: Wed, 3 Sep 2008 14:09:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, arjan@infradead.org
Subject: Re: Blacklist DMAR on Intel G31/G33 chipsets
Message-ID: <20080903120926.GR18288@one.firstfloor.org>
References: <20080902061920.GK18288@one.firstfloor.org> <1220439231.2985.103.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220439231.2985.103.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -114,6 +128,10 @@ static struct chipset early_qrk[] __initdata = {
>  	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
>  	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
>  	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
> +#ifdef CONFIG_DMAR
> +	{ PCI_VENDOR_ID_INTEL, 0x29c0,
> +	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
> +#endif

Are you sure 0x29c0 is only used on the G31/G33?

-Andi

