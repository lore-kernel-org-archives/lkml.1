Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZHYN44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZHYN44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZHYN4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:56:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41662 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZHYN4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:56:55 -0400
From: "Paulraj, Sandeep" <s-paulraj@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>,
       Pablo Bitton <pablo.bitton@gmail.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 25 Aug 2009 08:56:08 -0500
Subject: RE: [PATCH v2] SPI: DaVinci: Adding SPI driver for DaVinci
Thread-Topic: [PATCH v2] SPI: DaVinci: Adding SPI driver for DaVinci
Thread-Index: Acolhtc6AXCHVMLmTF2XvcU7af0h6gAA5Wzg
Message-ID: <0554BEF07D437848AF01B9C9B5F0BC5D7F2A15BD@dlee01.ent.ti.com>
References: <20090817172612.1dfa74a5.pablo.bitton@gmail.com>
	<7448ec710908250504v1c5eb12fl109481a5d7716747@mail.gmail.com>
 <87skfgdo84.fsf@deeprootsystems.com>
In-Reply-To: <87skfgdo84.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

Please see inline

> 
> > The patch has received no comments so far (here and on spi-general-
> devel).
> >
> > Can someone test it on davinci's other that the DM6446 to see that
> support for
> > others has not broken?
> >
> > Kevin - Is there anything that keeps it from merging upstream to this
> tree?
> 
> Hi Pablo,
> 
> Sorry for the delay, I've been travelling and not able to watch
> DaVinci closely enough...
> 
> This driver should be merged via the SPI subsystem (maintained by
> David Brownell), not the Davinci core code which I maintain.
> 
> That being said, in my view, here's why this driver is not ready for
> upstream:
> 
> 1) The original driver from Sandeep that you based yours on was still
>    going through revisions.  The last review comments[1] from David
>    Brownell had not yet been addressed by Sandeep.  I hope that
>    Sandeep will have a chance to address the existing review comments
>    on his code, and then review yours.  However, you've made it
>    rather difficult to do that because...
[Sandeep] There were a set of comments from David Brownell(which was actually, thanks to him, in the from of a patch).
David did say that the SPI support in that form was ready for an initial merge. I tested it on DM355/Dm365 and Dm6467 and that driver(meant for the initial merge) is in our ARAGO tree.
Afcourse we all agreed that there are things to add in the SPI driver.
Also IIRC(and I am willing to be corrected) David did say that he would send it upstream when he got some time so I did not do it myself. The fact that he maintains the SPI subsystem had a part to play in my decision.
> 
> 2) You should have your patch apply on top of Sandeep's series, not
>    just absorb it.  That way we can clearly see what you are adding
>    and/or changing from Sandeeps original driver.  To make this part
>    easier, I created a 'temp/spi' branch of davinci git where I've
>    pushed the latest versions of the patches from Sandeep.  Any
>    additions/updates/fixes you have should be posted as patches
>    against that for easier discussion and review.
> 
> 3) As Sandeep did, you should keep the changes to the board/SoC code
>    (arch/arm/mach-davinci/*) as a separate patch from the driver code
>    (drivers/spi/*)
> 
> 4) this driver needs more testing
[Sandeep] tested by TI test team on DM355 and DM365 and I have tested on DM6467.
> 
> > So far, the patch has been added to the -mm tree - http://git.zen-
> sources.org/?
> > p=mmotm.git;a=commit;h=b693ea09ae2fb5c382ef7f2772d6115af1f9b4fc.
> > Its filename is spi-davinci-adding-spi-driver-for-davinci.patch.
> 
> Andrew, I would recommend dropping this from -mm until the
> above issues are addressed.
> 
> Thanks,
> 
> Kevin  (maintainer: arch/arm/mach-davinci/*)
Thanks,
Sandeep
