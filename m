Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbXCTK4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbXCTK4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXCTK4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:56:54 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4003 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbXCTK4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:56:53 -0400
Date: Tue, 20 Mar 2007 10:56:41 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070320105641.GA29198@flint.arm.linux.org.uk>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	sam@ravnborg.org
References: <1173394873.3461.510.camel@pmac.infradead.org> <20070319164243.026fdbfd.akpm@linux-foundation.org> <1174376588.3392.168.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174376588.3392.168.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 07:43:08AM +0000, David Woodhouse wrote:
> On Mon, 2007-03-19 at 16:42 -0700, Andrew Morton wrote:
> > hm, did you try running this on x86_64?
> 
> I don't have any. I only tested it on PowerPC and i386. Others then
> provided more exclusions for SPARC and maybe ARM, although I'm not sure
> you have the latter yet. It's not hard to add extra exclusions.

Some of the ones which come up on x86_64 also come up on ARM for the
same reason; they're obsolete system calls which probably shouldn't
be implemented on anything but legacy i386.  Things like waitpid, etc.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
