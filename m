Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbXBETA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbXBETA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933370AbXBETA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:00:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45269 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933367AbXBETAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:00:25 -0500
Date: Mon, 5 Feb 2007 19:13:18 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Allen Martin <AMartin@nvidia.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Nvidia cable detection problems (was [PATCH] amd74xx: don't
 configure udma mode higher than BIOS did)
Message-ID: <20070205191318.39f84ced@localhost.localdomain>
In-Reply-To: <45C77921.4020808@gmail.com>
References: <20070205075836.GG1625@htj.dyndns.org>
	<20070205112410.5a3c3182@localhost.localdomain>
	<45C72012.7050605@gmail.com>
	<20070205132247.6f611e3c@localhost.localdomain>
	<45C73A3E.6080700@gmail.com>
	<20070205143439.6962c076@localhost.localdomain>
	<45C7444F.4070500@gmail.com>
	<58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>
	<DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com>
	<20070205181224.3319d6c3@localhost.localdomain>
	<45C77921.4020808@gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well we can certainly do some of that if ACPI is present and active. In
> > particular since _GTM will give us current modes allowing for hotplug and
> > post BIOS boot kexec etc it ought to be safe to do Tejun's hack that way.
> > We could even probe UDMA3+ capable devices by doing _STM to a high mode
> > and _GTM to determine the cable type 8)
> 
> Glad to see the problem getting solved.  Now that we know the solution,
> any volunteers?  :-)

I am currently putting together an experimental pata_acpi driver to play
with this stuff. May take a bit of time while I work out the current acpi
interface gunge and how to expand it.

The fact we have to try each mode to see what we can set doesn't make it
pretty either!

Alan
