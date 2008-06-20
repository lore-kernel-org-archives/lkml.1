Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbYFTPcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbYFTPcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758285AbYFTPcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:32:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039AbYFTPcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:32:35 -0400
Date: Fri, 20 Jun 2008 17:32:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap
Message-ID: <20080620153220.GD17373@elte.hu>
References: <1213916250.27983.35.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213916250.27983.35.camel@promb-2n-dhcp368.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> This is a preparatory patch for the next patch in series. Moves some 
> code from e820_setup_gap to a new function e820_search_gap. This 
> function will be used by the next patch in the series.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> 
> Index: linux-2.6/arch/x86/kernel/e820_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820_64.c	2008-06-12 10:42:22.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/e820_64.c	2008-06-13 14:05:18.000000000 -0700
> @@ -872,26 +872,20 @@

note that this code has significantly changed in x86-next (it has been 
fixed, extended, cleaned up and unified). You can find the latest 
patches in tip/master at:

  http://people.redhat.com/mingo/tip.git/README

tip/master contains the integration of all changes in this area.

We could apply and test your change in tip/x86 as well, as it seems 
standalone and independent of ACPI - so that when the acpi change shows 
up in linux-next there's a e820_search_gap() function available.

	Ingo
