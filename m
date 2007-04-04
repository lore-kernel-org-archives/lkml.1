Return-Path: <linux-kernel-owner+w=401wt.eu-S2992746AbXDDIiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992746AbXDDIiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992747AbXDDIiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:38:14 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992746AbXDDIiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:38:13 -0400
Date: Wed, 4 Apr 2007 09:38:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404083803.GA13134@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <1175663999.2932.8.camel@shinybook.infradead.org> <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404.011208.120446173.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:12:08AM -0700, David Miller wrote:
> Your ARM example holds zero water because that platform has all kinds
> of weird devices so people there are used to all kinds of non-standard
> conventions and naming.

I think your perception is more wrong than you could ever think.
Montavista would absolutely love all serial ports to be under the
ttyS* naming, especially on ARM where there is a wide variety of
different possibilities - ttyAM, ttySA, ttyPXA, ttyAMA, and so
the list goes on.  It apparantly gives their support department
real headaches.

There are similar feelings from the handhelds.org community.

However, despite people pressing for it, there's yet to be a *sane*
*technical* *solution* to the problem.  All I've seen so far is one
bad hack.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
