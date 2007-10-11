Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXJKT43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXJKT43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXJKT4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:56:21 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:36921 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbXJKT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:56:21 -0400
Date: Thu, 11 Oct 2007 14:55:44 -0500
From: Scott Wood <scottwood@freescale.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, grundler@parisc-linux.org,
       kyle@parisc-linux.org, linuxppc-dev@ozlabs.org, lethal@linux-sh.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] powerpc: Switch to generic WARN_ON()/BUG_ON()
Message-ID: <20071011195544.GA4247@loki.buserror.net>
References: <20071011171211.GB10877@lixom.net> <20071011171413.GC10877@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011171413.GC10877@lixom.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 12:14:13PM -0500, Olof Johansson wrote:
> Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
> 4K text on a ppc64_defconfig. The main reason seems to be that prepping
> the arguments to the conditional trap instructions is more work than
> just doing a compare and branch.

It'd be nice if we could get GCC to generate bug table entries for
__builtin_trap(); that way we could use GCC's ability to put arbitrary
conditions in the trap instruction.

-Scott
