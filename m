Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZDTUdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZDTUdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZDTUdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:33:43 -0400
Received: from relay3.sgi.com ([192.48.156.57]:56005 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756343AbZDTUdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:33:42 -0400
Date: Mon, 20 Apr 2009 15:33:38 -0500
From: Jack Steiner <steiner@sgi.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Weidong Han <weidong.han@intel.com>
Subject: Re: [patch 5/5] x2apic, IR: Make config X86_UV dependent on X86_X2APIC
Message-ID: <20090420203338.GA8286@sgi.com>
References: <20090420200450.128993000@linux-os.sc.intel.com> <20090420200450.694598000@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420200450.694598000@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 01:02:31PM -0700, Suresh Siddha wrote:
> Instead of selecting X86_X2APIC, make config X86_UV dependent on X86_X2APIC.
> This will eliminate enabling CONFIG_X86_X2APIC with out enabling
> CONFIG_INTR_REMAP.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Weidong Han <weidong.han@intel.com>
> Cc: Jack Steiner <steiner@sgi.com>

Acked-by: Jack Steiner <steiner@sgi.com>

> ---
> 
> Index: tip/arch/x86/Kconfig
> ===================================================================
> --- tip.orig/arch/x86/Kconfig
> +++ tip/arch/x86/Kconfig
> @@ -356,7 +356,7 @@ config X86_UV
>  	depends on X86_64
>  	depends on X86_EXTENDED_PLATFORM
>  	depends on NUMA
> -	select X86_X2APIC
> +	depends on X86_X2APIC
>  	---help---
>  	  This option is needed in order to support SGI Ultraviolet systems.
>  	  If you don't have one of these, you should say N here.
> 
> -- 
