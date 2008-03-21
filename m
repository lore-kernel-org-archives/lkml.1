Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYCUK6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYCUK6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYCUK6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:58:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41605 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031AbYCUK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:58:05 -0400
Date: Fri, 21 Mar 2008 10:42:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: osb972ww-linuxczmil@yahoo.com
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Message-ID: <20080321104237.72379e41@core>
In-Reply-To: <217535.99274.qm@web34505.mail.mud.yahoo.com>
References: <217535.99274.qm@web34505.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 20:04:13 -0700 (PDT)
osb972ww-linuxczmil@yahoo.com wrote:

> 
> HI Tejun,
> 
>   setting irqpoll fixed both problems, and there are no "nasty grams" in dmesg now.   The original reason I was trying to use the hdparm -u on /dev/sda was because it was hanging for a few seconds when doing writes to the CFdisk, and in the past that was the kind of thing that hdparm -u would generally fix.   Now with the irqpoll kernel option, the /dev/sdb SATA drive was found, and I can mount it and write to it.  The CFcard /dev/sda is also responding to writes better than before.
> 
> Thanks for the suggestion to use irqpoll.    What is the problem within the driver(s) that is requiring irqpoll. ?

irqpoll works around BIOS bugs not driver bugs (well generally speaking
anyway).

Alan
