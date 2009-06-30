Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZF3WKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZF3WKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZF3WK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:10:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZF3WKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:10:25 -0400
Date: Wed, 1 Jul 2009 00:10:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jan Beulich <JBeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/ia64: adjust section annotation for  pcibios_setup()
Message-ID: <20090630221016.GF1241@elte.hu>
References: <4A4A11AF020000780000831D@vpn.id2.novell.com> <57C9024A16AD2D4C97DC78E552063EA3A8D9EA80@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3A8D9EA80@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> --- linux-2.6.31-rc1/arch/ia64/pci/pci.c	2009-06-26 17:49:37.000000000 +0200
> +++ 2.6.31-rc1-pcibios_setup/arch/ia64/pci/pci.c	2009-05-04 11:39:32.000000000 +0200
> @@ -537,7 +537,7 @@ pcibios_align_resource (void *data, stru
>  /*
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

I think this one's for Jesse's PCI tree.

	Ingo
