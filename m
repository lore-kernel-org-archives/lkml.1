Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZAaOIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZAaOIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZAaOIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:08:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZAaOIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:08:15 -0500
Date: Sat, 31 Jan 2009 14:08:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH F 06/12] OMAP2/3 clock: every clock must have a clkdm
Message-ID: <20090131140804.GH1394@n2100.arm.linux.org.uk>
References: <20090128193326.2396.9437.stgit@localhost.localdomain> <20090128193512.2396.75340.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128193512.2396.75340.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:35:15PM -0700, Paul Walmsley wrote:
> Every OMAP2/3 clock must now have an assigned clockdomain, so we can
> remove the checks from clk_enable()/clk_disable().  Instead, verify
> that the clockdomain is present only at clock init time via the
> arch_clock clk_register() hook.

I don't see the point of requiring all clocks to have a clockdomain field.
Given that we have virtual clocks, it is quite reasonable for some clocks
not to have a clock domain associated with them.

The overhead for avoiding this requirement isn't that great, and I feel
that there's little benefit from this change.
