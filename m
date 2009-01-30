Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZA3Frw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZA3Frw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 00:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZA3Frn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 00:47:43 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:42355 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZA3Frm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 00:47:42 -0500
Date: Thu, 29 Jan 2009 22:47:40 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH C 06/13] OMAP3 clock: DPLLs should enter bypass if new
 rate is sys_ck
In-Reply-To: <20090129123936.GA16644@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0901292244211.26985@utopia.booyaka.com>
References: <20090128190724.12092.22239.stgit@localhost.localdomain> <20090128190823.12092.2638.stgit@localhost.localdomain> <20090129123936.GA16644@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

this E-mail responds to your comments on patches C 04 through C 08.  
My understanding is that you'd like me to:

1. Compress patches C 04 through C 09;

2. Modify omap3_noncore_dpll_enable() to move the "if (!ret)
   clk->rate = rate" outside and below the conditional;

3. Remove some of the blank lines before and after braces in C 06;

4. Modify the DPLL bypass clock handling to change the DPLL's clk->parent,
   rather than return the bypass clock rate.

The above all make sense to me, and #4, if it works in practice, should be 
a significant improvement over the existing code.

If this is what you're looking for, I'll send a compressed, modified 
patch.  Would you like it to be based on the codebase post C 03, or 
against another commit?

regards,

- Paul

