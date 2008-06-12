Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYFLCup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYFLCup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYFLCue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:50:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45473 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbYFLCue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:50:34 -0400
Message-ID: <48508EF7.9070309@garzik.org>
Date: Wed, 11 Jun 2008 22:50:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: What do these SATA errors mean / kernel 2.6.25.6 (DRDY ERR/ICRC
 ABRT)
References: <alpine.DEB.1.10.0806110608080.7726@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0806110608080.7726@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Never had a single error so far, powered down my host, powered it back up,
> and now with kernel 2.6.25.6:

http://ata.wiki.kernel.org/index.php/Libata_error_messages

In particular, timeouts may be solved by acpi=off or 'noapic' or
pci=nomsi or pci=biosirq.


> Does/the kernel handle the ATA v8 protocol properly?
> ATA Version is:   8

Yes.  ATA is always back-compatible.

	Jeff





