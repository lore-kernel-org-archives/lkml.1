Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907Ab0A2Xp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0A2Xp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523Ab0A2Xp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:45:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55119 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0A2Xp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:45:27 -0500
Date: Fri, 29 Jan 2010 23:45:01 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: arm tree build failure
Message-ID: <20100129234501.GA31198@flint.arm.linux.org.uk>
References: <20100129103837.02cc865f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129103837.02cc865f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:38:37AM +1100, Stephen Rothwell wrote:
> Hi Russell,
> 
> Yesterday's linux-next (next-20100128) build (arm versatile_defconfig)
> failed like this:
> 
> arch/arm/mach-versatile/core.c: In function 'versatile_init':
> arch/arm/mach-versatile/core.c:838: error: 'i' undeclared (first use in this function)
> 
> Looks like a bad merge (commit b7cdd38da36d61d0f42367057c9d04678644317a
> "Merge branch 'versatile' into devel").

Thanks for catching that, now fixed.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
