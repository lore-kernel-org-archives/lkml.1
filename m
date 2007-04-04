Return-Path: <linux-kernel-owner+w=401wt.eu-S2992770AbXDDJA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992770AbXDDJA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992774AbXDDJA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:00:27 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2211 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992770AbXDDJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:00:26 -0400
Date: Wed, 4 Apr 2007 10:00:16 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404090016.GC13134@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net> <20070404083803.GA13134@flint.arm.linux.org.uk> <20070404.014330.91315500.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404.014330.91315500.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:43:30AM -0700, David Miller wrote:
> From: Russell King <rmk+lkml@arm.linux.org.uk>
> Date: Wed, 4 Apr 2007 09:38:03 +0100
> 
> > However, despite people pressing for it, there's yet to be a *sane*
> > *technical* *solution* to the problem.  All I've seen so far is one
> > bad hack.
> 
> Well the "bad hack" we use on sparc gives usable serial ports,
> properly ordered and using /dev/ttyS0, with a proper matching
> console selection.

Well yes, but it seems to have code in the architecture's early
command line parsing to parse the "console=" argument to set this
magical "serial_console" variable.

Is this an approach you recommend for all architectures?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
