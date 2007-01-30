Return-Path: <linux-kernel-owner+w=401wt.eu-S965542AbXA3OqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542AbXA3OqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965545AbXA3OqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:46:23 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37577 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965542AbXA3OqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:46:21 -0500
Date: Tue, 30 Jan 2007 14:56:29 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <jdelvare@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: via irq quirk breakage
Message-ID: <20070130145629.7e40deac@localhost.localdomain>
In-Reply-To: <200701300854.06083.jdelvare@suse.de>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701291600.32580.jdelvare@suse.de>
	<45BEAEE3.9080003@yahoo.com.au>
	<200701300854.06083.jdelvare@suse.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You have an old VT82C686 south bridge, which was tagged as "special" by
> Alan. For this chip, Alan's code only allows devices 00:00.x to be quirked.
> As my code was merely a reimplementation of Alan's idea, it does the same.
> Your USB controllers are at 00:07.x, so I'm not surprised they weren't
> quirked.
> 
> Alan, why were dev_lo and dev_hi both set to 0 for the VT82C868 in your
> implementation? Is it a typo, or...?

According to the documentation the VT82C686 has the following devices on
the internal bus: bus 0 dev ? fn 0-6.  dev ? being the device of the
bridge itself. Re-reading the docs unlike the other the PCI idents aren't
fixed so my assumption of dev 0 is actually unsafe. I can't see anything
in the doc which guarantees 7 either.

Alan
