Return-Path: <linux-kernel-owner+w=401wt.eu-S965055AbXBTPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbXBTPjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965075AbXBTPjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:39:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45128 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965055AbXBTPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:39:18 -0500
Date: Tue, 20 Feb 2007 16:42:50 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_amd dropping to PIO on resume
Message-ID: <20070220164250.24fad51c@localhost.localdomain>
In-Reply-To: <45DB137F.1060301@garzik.org>
References: <fa.q7ZuddHInqn2dVlS+EWjXjPvFC8@ifi.uio.no>
	<45D63BCE.2080700@shaw.ca>
	<45D6436C.4060209@garzik.org>
	<20070219220812.11c3baba@localhost.localdomain>
	<45DB137F.1060301@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> places where the bit must be twiddled.  Its easier to leave the bit in 
> the BIOS-initialized state, and ignore the hardware bit's existence in 
> software, if we know the behavior in the controller is hardwired.  Less 
> room for software bugs that way, IMO.

The AMD docs don't categorically answer that question either way that I
can see. The bit appears to make no difference but.. 

Alan
