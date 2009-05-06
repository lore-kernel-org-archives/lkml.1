Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZEFTFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZEFTFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZEFTEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:04:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33450 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZEFTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:04:52 -0400
Date: Wed, 6 May 2009 20:04:08 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Wolfram Sang <w.sang@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the i2c tree with the arm-current
	tree
Message-ID: <20090506190408.GC6897@flint.arm.linux.org.uk>
References: <20090506131031.83f1b04d.sfr@canb.auug.org.au> <20090506103138.79525cd0@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506103138.79525cd0@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 10:31:38AM +0200, Jean Delvare wrote:
> I don't know exactly how defconfigs are handled, but I can imagine that
> the responsible developer is running "make oldconfig" on the system in
> question from times to times and copying the result back to the
> defconfig file. The purpose of updating defconfig files is to make
> configuration option renames transparent.

The big problem is that everyone 'make oldconfig' is done, the entire
config file essentially gets re-sorted into some other random order,
and the changes are massive.

If a platform maintainer does this, and the result is committed, and
some other person has done some small sed-based updates to the defconfigs,
the result is _total_ chaos.

That's why I'm arguing for my approach.  That way, platform maintainers
stand a better chance of seeing what happens to their defconfig files
and there's a substantially better chance of some coordination of those
changes (that is if the arch maintainer is doing their job properly.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
