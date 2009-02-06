Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZBFVpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZBFVpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZBFVpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:45:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33790 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZBFVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:45:01 -0500
Date: Fri, 6 Feb 2009 21:44:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH D 11/11] Fix omap1 clock issues
Message-ID: <20090206214450.GN13758@n2100.arm.linux.org.uk>
References: <20090128191638.16688.33452.stgit@localhost.localdomain> <20090128191844.16688.39372.stgit@localhost.localdomain> <20090129143733.GB18233@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0902061417390.26737@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902061417390.26737@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 02:19:34PM -0700, Paul Walmsley wrote:
> [paul@pwsan.com: This patch has been updated to use offsets for OMAP1 
> clock enable registers, to resolve all current sparse warnings with the 
> clock code, and to convert most magic constants into symbolic macros.  

Wish you hadn't; I've been avoiding the patches changing the way registers
are accessed for the time being - until I have an opportunity to think
about them for a bit.

As can be seen in the OMAP2 updates, this approach causes additional
struct clk's to appear for mcbsp clocks because they have controlling
registers split across two subsystems.  This is contary to one of your
other statements about wanting the struct clk's to reflect the real
clock structure without virtual clocks.
