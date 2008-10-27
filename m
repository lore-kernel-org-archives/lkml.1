Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYJ0KHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYJ0KHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYJ0KHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:07:09 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37522 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYJ0KHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:07:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18693.37494.214451.346748@harpo.it.uu.se>
Date: Mon, 27 Oct 2008 11:05:42 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mikael Pettersson <mikpe@it.uu.se>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.28-rc2] i386: fix forbid_dac linkage error when
	CONFIG_PCI=n
In-Reply-To: <20081027094157.GB4278@elte.hu>
References: <200810270817.m9R8HsJu029399@harpo.it.uu.se>
	<20081027094157.GB4278@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > 
 > * Mikael Pettersson <mikpe@it.uu.se> wrote:
 > 
 > > Fix 2.6.28-rc2 build failure on i386 with CONFIG_PCI=n:
 > 
 > > +#ifdef CONFIG_PCI
 > >  		if (!strncmp(p, "allowdac", 8))
 > >  			forbid_dac = 0;
 > >  		if (!strncmp(p, "nodac", 5))
 > > @@ -210,6 +211,7 @@ static __init int iommu_setup(char *p)
 > >  			forbid_dac = -1;
 > >  			return 1;
 > >  		}
 > > +#endif /* CONFIG_PCI */
 > 
 > there's a better fix for this queued up in the PCI tree, see:
 > 
 >  http://marc.info/?l=linux-kernel&m=122480590627590&w=2

Got it. Thanks.

/Mikael
