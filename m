Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZAaOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZAaOWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZAaOWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:22:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54550 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZAaOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:22:07 -0500
Date: Sat, 31 Jan 2009 14:21:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH B 05/10] OMAP2/3 clock: add clockdomains to all remaining clocks; fix clkdm init
Message-ID: <20090131142153.GK1394@n2100.arm.linux.org.uk>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024418.27240.52292.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128024418.27240.52292.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:44:21PM -0700, Paul Walmsley wrote:
> Add clockdomains for all remaining clocks without them, and warn in
> clk_register() if any are missing a clockdomain.  On OMAP2, call
> omap2_init_clk_clkdm() immediately after clk_register(), just as OMAP3
> does.  Remove omap2_init_clk_clkdm() from all of the struct clk .init
> function pointers, since the OMAP2/3 arch clock init code now calls it.

Probably the same comment as B4.
