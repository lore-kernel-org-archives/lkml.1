Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZF3X2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZF3X2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbZF3X1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:27:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:27812 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbZF3X1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:27:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,319,1243839600"; 
   d="scan'208";a="160241155"
Date: Tue, 30 Jun 2009 16:27:43 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jan Beulich <JBeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/ia64: adjust section annotation for 
 pcibios_setup()
Message-ID: <20090630162743.6a2a15f6@jbarnes-g45>
In-Reply-To: <20090630221016.GF1241@elte.hu>
References: <4A4A11AF020000780000831D@vpn.id2.novell.com>
	<57C9024A16AD2D4C97DC78E552063EA3A8D9EA80@orsmsx505.amr.corp.intel.com>
	<20090630221016.GF1241@elte.hu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 00:10:16 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Luck, Tony <tony.luck@intel.com> wrote:
> 
> --- linux-2.6.31-rc1/arch/ia64/pci/pci.c	2009-06-26
> 17:49:37.000000000 +0200 +++
> 2.6.31-rc1-pcibios_setup/arch/ia64/pci/pci.c	2009-05-04
> 11:39:32.000000000 +0200 @@ -537,7 +537,7 @@ pcibios_align_resource
> (void *data, stru /*
>   * PCI BIOS setup, always defaults to SAL interface
>   */
> -char * __devinit
> +char * __init
>  pcibios_setup (char *str)
>  {
>  	return str;
> 
> ia64 part Acked-by: Tony Luck <tony.luck@intel.com>
> 
> Ingo/Thomas/Peter: please run this through the tip tree.
> 
> I think this one's for Jesse's PCI tree.

Stuffed it into my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
