Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbXBEVti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbXBEVti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933494AbXBEVti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:49:38 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42539 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933492AbXBEVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:49:37 -0500
Date: Mon, 5 Feb 2007 22:02:32 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "Tejun Heo" <htejun@gmail.com>, "Allen Martin" <AMartin@nvidia.com>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Nvidia cable detection problems (was [PATCH] amd74xx: don't
 configure udma mode higher than BIOS did)
Message-ID: <20070205220232.3e73297b@localhost.localdomain>
In-Reply-To: <58cb370e0702051327p7b253dafs439c937093ca837d@mail.gmail.com>
References: <20070205075836.GG1625@htj.dyndns.org>
	<20070205132247.6f611e3c@localhost.localdomain>
	<45C73A3E.6080700@gmail.com>
	<20070205143439.6962c076@localhost.localdomain>
	<45C7444F.4070500@gmail.com>
	<58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>
	<DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com>
	<20070205181224.3319d6c3@localhost.localdomain>
	<45C77921.4020808@gmail.com>
	<58cb370e0702051055w3c7dcff3wd3e3b4935b910b41@mail.gmail.com>
	<58cb370e0702051327p7b253dafs439c937093ca837d@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Since we are already using UDMA mode set by BIOS to determine if 80c cable
> is present so why not also use it to determine if the 40c cable is present?
> 
> I mean just ignoring AMD_CABLE_DETECT register for NVIDIA devices.
> 
> 2-lines change and we wouldn't have to deal with ACPI at ell.

And as I explained earlier you get false values. The existing hack is
dodgy as well and breaks on suspend/resume then loading the driver for
one. It's probably the best that can be done without ACPI but the ACPI
_GTM/_STM methods are pretty clean so its not hard to use them. You need
them for full suspend/resume support anyway.

Alan
