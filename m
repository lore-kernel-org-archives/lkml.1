Return-Path: <linux-kernel-owner+w=401wt.eu-S1946164AbXBPVDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946164AbXBPVDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946208AbXBPVDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:03:09 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:52452 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946164AbXBPVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:03:08 -0500
Date: Fri, 16 Feb 2007 22:03:28 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070216210328.GE4641@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <20070216191207.GC2572@flint.arm.linux.org.uk> <20070216204336.GB4641@enneenne.com> <20070216205134.GF2572@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216205134.GF2572@flint.arm.linux.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 08:51:35PM +0000, Russell King wrote:
> 
> You can't because it doesn't go through the interfaces you're hooking
> into.  Existing interfaces are "changed" to point at the UARTs using
> setserial, which does its work via an ioctl.

I see.

> Not specifically only userland - if it happens to be set when the port
> is registered then enable PPS support then as well.
> 
> So:
> 
> 1. uart_configure_port - if UPF_HARDPPS_CD is set, register the port
>    for PPS support.
> 2. uart_remove_one_port - if UPF_HARDPPS_CD is set, unregister the port
>    for PPS support.
> 3. uart_set_info - if changing UPF_HARDPPS_CD, appropriately register or
>    unregister the port for PPS support.

Ok. I'm going to study how to modify the code.

> PS, linuxpps@ml.enneenne.com dropped from the cc: since it rejects my
> postings.

I just fixed my spam filter (at least I hope so :).

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
