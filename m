Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbXBEVvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbXBEVvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933504AbXBEVvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:51:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42549 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933500AbXBEVvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:51:50 -0500
Date: Mon, 5 Feb 2007 22:04:42 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: "Allen Martin" <AMartin@nvidia.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: Nvidia cable detection problems & ACPI (beware, slight off-top)
Message-ID: <20070205220442.6e13a7b6@localhost.localdomain>
In-Reply-To: <E1HEB7U-0007IH-FV@flower>
References: <20070205075836.GG1625@htj.dyndns.org>
	<20070205112410.5a3c3182@localhost.localdomain>
	<45C72012.7050605@gmail.com>
	<20070205132247.6f611e3c@localhost.localdomain>
	<45C73A3E.6080700@gmail.com>
	<20070205143439.6962c076@localhost.localdomain>
	<45C7444F.4070500@gmail.com>
	<58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>
	<DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com>
	<E1HEB7U-0007IH-FV@flower>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm very upset, that hardware nvidia-lego forces system software (and
> programmers) to know "unfortunately no standard" ways of desinging
> things... One read-only-for-os, hardware set bit in kind of control

The hardware doesn't. The BIOS authors do by not setting the cable flags.
We actually need to use the STM and GTM methods for PC suspend/resume so
it makes sense to see if they will work out in this case too.

Alan
