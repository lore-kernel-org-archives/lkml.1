Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZAaOJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZAaOJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZAaOJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:09:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58134 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZAaOJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:09:45 -0500
Date: Sat, 31 Jan 2009 14:09:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: Re: [PATCH B 03/10] OMAP2/3 clockdomains: add CM, PRM, virt_opp_clkdm clockdomains
Message-ID: <20090131140935.GI1394@n2100.arm.linux.org.uk>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024411.27240.28757.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128024411.27240.28757.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:44:15PM -0700, Paul Walmsley wrote:
> Add clockdomains for the CM and PRM.  These replace "wkup_clkdm", a
> placeholder clockdomain which does not exist on the hardware.  Add a
> clockdomain for virtual OPP clocks, "virt_opp_clkdm".  Mark all clocks
> in the clock tree with a valid clockdomain.
> 
> The following TI documents are used as reference:
> 
> OMAP2420 Multimedia Processor Silicon Revision 2.1.1, 2.2 TRM Version Q
> OMAP34xx Multimedia Device Silicon Revision 3.0 Version I TRM
> OMAP34xx Multimedia High Security (HS) Device Silicon Revision 3.0 Security
>     Addendum Version B TRM
> 
> This patch includes an earlier fix to sys_clkout2's clockdomain by
> Tomi Valkeinen <tomi.valkeinen@nokia.com>.
> 
> linux-omap source commits are a4061e5422dae1433264b40178f73dc6f1d6d748,
> 859207f04c6b64ee714a65a58ee629ddde91bfa8, and
> f34f5bdd731fe828241d729fd465612a56d7e35f.

Given my comments on F6, I've so far avoided merging 859207f.
