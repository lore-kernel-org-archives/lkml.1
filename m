Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbXITHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbXITHXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXITHXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:23:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46465 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXITHXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:23:08 -0400
Date: Thu, 20 Sep 2007 08:22:33 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM:  Drop support for redundant "keepinitrd" boot-time param.
Message-ID: <20070920072233.GA10410@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64.0709191203460.30041@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709191203460.30041@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 12:06:44PM -0400, Robert P. J. Day wrote:
> Given the equivalent "retain_initrd" boot-time paramater, "keepinitrd"
> appears to be entirely superfluous.

NAK.  "keepinitrd" is what people expect on ARM.

I'm frustrated that whoever invented "retain_initrd" didn't look around
in the documentation to see if there was any existing implementation
first.  The generic implementation should be fixed IMHO, or at least
the option string moved into init/initramfs.c.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
