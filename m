Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbXCTIwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbXCTIwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 04:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbXCTIwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 04:52:08 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXCTIwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 04:52:07 -0400
Date: Tue, 20 Mar 2007 08:51:56 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Keith Owens <kaos@ocs.com.au>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com
Subject: Re: PNPACPI probes serial twice, messes up serial console
Message-ID: <20070320085156.GA19799@flint.arm.linux.org.uk>
Mail-Followup-To: Keith Owens <kaos@ocs.com.au>,
	linux-kernel@vger.kernel.org, len.brown@intel.com
References: <17887.1174373206@kao2.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17887.1174373206@kao2.melbourne.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 05:46:46PM +1100, Keith Owens wrote:
> Should pnpacpi probe and setup the serial devices even when thay have
> already been setup?  Or this is something strange about the UART in
> this particular box?

Yes, so it can be associated with the correct device.

No idea why it's affecting your serial console though - the autoconfig
should be transparent once it's completed.  Sure, if you enable
serial debugging (thereby making it produce output during the autoconfig)
it will mess it up, but that's the standard gun and foot scenario.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
