Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYIUUDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYIUUDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYIUUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:02:55 -0400
Received: from ppp-111-195.adsl.restena.lu ([158.64.111.195]:40240 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750877AbYIUUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:02:54 -0400
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2008 16:02:54 EDT
Date: Sun, 21 Sep 2008 21:51:57 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Mark Lord <liml@rtr.ca>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for
 CX700)
Message-ID: <20080921215157.449ef5b7@neptune.home>
In-Reply-To: <48CFEE51.2070200@kernel.org>
References: <20080911193511.7960bc82@neptune.home>
	<48CE22E5.9090403@kernel.org>
	<20080915190242.58d21a8f@neptune.home>
	<48CEC8F2.4040904@kernel.org>
	<20080916102152.3f35439f@pluto.restena.lu>
	<48CFEE51.2070200@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 16 September 2008 Tejun Heo <tj@kernel.org> wrote:
> > Just for the record, on the VIA there were no errors yet with
> > 2.6.27-rc6-git3 though I ran some compiling on it. As such it
> > *could* be that one of the patches pushed by Jeff helped:
> >   [libata] LBA28/LBA48 off-by-one bug in ata.h
> >   sata_inic162x: enable LED blinking
> >   ata: duplicate variable sparse warning
> 
> The only patch which could have affected the result is the off-by-one
> one; however, FLUSH timeout is a bit unexpected failure mode for the
> problem.  Can you please keep the system running for a whlie and see
> whether the problem occurs?

I haven't seen the error happen yet with 2.6.27-rc6-git3, so that off
by one bug might have had an incidence.
No warranty on that as I did also slightly change power-saving settings
for the disk around the time I updated kernel (-B254, -S241 parameters
to hdparm) and have not seen the error yet on 2.6.27-rc5-git9 since
then.

Will do more testing as time permits over the next days and report if I
find anything that looks useful (e.g. better way than time to trigger
the error or some of the hdparm options influencing the probability)

In case there is a patch that would eventually be able to get more info
when the error occurs I would be happy to apply it.

Bruno
