Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752751AbYLRTbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYLRTbb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLRTbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:31:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41470 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYLRTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:31:20 -0500
Date: Thu, 18 Dec 2008 19:30:59 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, "Helight.Xu" <helight.xu@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix some code style that line over 80 characters
Message-ID: <20081218193059.GA31274@flint.arm.linux.org.uk>
References: <20081210135143.GB4595@helight> <20081210150116.GB21396@x200.localdomain> <20081218112617.09fd97bd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218112617.09fd97bd.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 11:26:17AM -0800, Randy Dunlap wrote:
> On Wed, 10 Dec 2008 18:01:16 +0300 Alexey Dobriyan wrote:
> 
> > On Wed, Dec 10, 2008 at 09:51:43PM +0800, Helight.Xu wrote:
> > > -static inline struct s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> > > +static inline struct
> > > +s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> > 
> > NAK!
> 
> OK, but please includes reason(s) for NAKs...

I can provide a reason - it splits "struct" and the structure name
across different lines.  That manes 'struct s3c2410_platform_i2c'
hard to grep for.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
