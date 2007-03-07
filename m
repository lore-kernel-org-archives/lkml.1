Return-Path: <linux-kernel-owner+w=401wt.eu-S1422883AbXCGRf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422883AbXCGRf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422959AbXCGRfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:35:55 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3953 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422886AbXCGRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:35:38 -0500
Date: Wed, 7 Mar 2007 17:35:13 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Mollett <molletts@yahoo.com>
Cc: linux-parport@lists.infradead.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tim Waugh <tim@cyberelk.net>
Subject: Re: [Linux-parport] Linux v2.6.21-rc3
Message-ID: <20070307173512.GA2512@flint.arm.linux.org.uk>
Mail-Followup-To: Stephen Mollett <molletts@yahoo.com>,
	linux-parport@lists.infradead.org,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Tim Waugh <tim@cyberelk.net>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <45EEB99D.7020406@googlemail.com> <200703071714.21572.molletts@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703071714.21572.molletts@yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 05:14:21PM +0000, Stephen Mollett wrote:
> On Wednesday 07 Mar 2007, Michal Piotrowski wrote:
> > BTW. Does anyone care about parport console?
> > console=lp0 hangs since at least 2.6.18
> 
> For the record, I used console=lp0 quite recently (stock 2.6.19 according to 
> the printout, running on i386) [to find out what was causing a panic that 
> immediately vanished off the top of the screen because of "atkbd.c: Spurious 
> ACK..."s from the flashing kb LEDs] and it worked just fine.

ISTR lp consoles block indefinitely until the printer is ready, so
if you ask for a lp console but don't have a working printer connected
it will hang.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
