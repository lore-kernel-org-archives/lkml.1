Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbXCMPcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbXCMPcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXCMPcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:32:54 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:38022 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXCMPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:32:53 -0400
Date: Tue, 13 Mar 2007 11:32:52 -0400
To: Mark Lord <lkml@rtr.ca>
Cc: Phil Kaslo <phil@cs.arizona.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Asus P5B-VM motherboard:  cd drive malfunctions if internal nic in use.
Message-ID: <20070313153252.GC22466@csclub.uwaterloo.ca>
References: <200703122212.l2CMCaxm032601@osprey.cs.arizona.edu> <45F5D59E.10304@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F5D59E.10304@rtr.ca>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 06:35:10PM -0400, Mark Lord wrote:
> Is that a PATA cd-drive?  If so, then you must have hooked it up
> to the JMicron IDE controller.  That driver is just plain buggy.
> 
> I gave up on it for my own P5B-VM.  The libata version works better
> than the drivers/ide, but I gave up on it and got a SATA DVD/RW drive.
> 
> Off topic:  do your USB ports power off when the system shuts down?
> Mine don't -- the +5V continues on them.. I'd love a tip on how to
> turn them off completely at shutdown.

Most Asus boards have jumpers for the USB ports to select between +5V
and +5VSB (stand by power).  The reason to provide standby power is so
that keyboards with power buttons can remain powered so that you can
turn the system on using the usb keyboard.  If you want to power off the
ports entirely, jumper them to the +5V line instead which only has power
when the system is on.

--
Len Sorensen
