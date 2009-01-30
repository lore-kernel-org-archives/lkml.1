Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbZA3Ipk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbZA3Ipk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZA3Ipb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:45:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53815 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZA3Ipa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:45:30 -0500
Date: Fri, 30 Jan 2009 08:45:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH A 01/10] OMAP2/3: Add non-CORE DPLL rate set code and M, N programming
Message-ID: <20090130084518.GA6864@n2100.arm.linux.org.uk>
References: <20090128020447.7244.80496.stgit@localhost.localdomain> <20090128021243.7244.6362.stgit@localhost.localdomain> <20090129142303.GA18233@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901292255530.26985@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901292255530.26985@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 10:57:24PM -0700, Paul Walmsley wrote:
> On Thu, 29 Jan 2009, Russell King - ARM Linux wrote:
> > Final point... this is only called from the function below, which also
> > checks that clk and clk->dpll_data are both non-NULL.  So these checks
> > are unnecessary.
> 
> Okay.  Do you want to take care of that in your merged version of this 
> patch, or would you like me to send an updated version, along with that 
> custom dpll4 set_rate function?

No thanks, I've already taken care of these - both were simple to address.
