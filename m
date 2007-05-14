Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbXENTvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbXENTvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXENTvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:51:00 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4713 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXENTvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:51:00 -0400
Date: Mon, 14 May 2007 20:50:46 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       bjorn.helgaas@hp.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: set RTS and DTR if flow is 'r'  --- resend
Message-ID: <20070514195046.GF29682@flint.arm.linux.org.uk>
Mail-Followup-To: Yinghai Lu <Yinghai.Lu@Sun.COM>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	bjorn.helgaas@hp.com, Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com> <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com> <46489BC2.6040403@sun.com> <4648A310.1050908@sun.com> <20070514181007.GA29682@flint.arm.linux.org.uk> <4648B2CC.2020403@sun.com> <20070514191905.GE29682@flint.arm.linux.org.uk> <4648BC93.8080909@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4648BC93.8080909@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:46:27PM -0700, Yinghai Lu wrote:
> Russell King wrote:
> >Still wrong, and unfortunately you haven't understood what I was saying
> >at all because this is worse. ;(
> >
> >Do not put the code in serial8250_set_termios.  It is the wrong place.
> >  
> 
> I don't want to put that there. the problem is serial8250_set_mctrl 
> called by will clear DTR bit.

We're at a stalemate then.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
