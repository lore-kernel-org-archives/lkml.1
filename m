Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZEAKcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZEAKcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZEAKbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:31:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48799 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752528AbZEAKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:31:51 -0400
Date: Fri, 1 May 2009 11:31:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?Um9n6XJpbw==?= Brito <rbrito@users.sf.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090501113129.3f11d4f5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501091804.GB29466@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
	<200904211459.26965.bzolnier@gmail.com>
	<20090423055618.GA23042@ime.usp.br>
	<200904232331.13729.bzolnier@gmail.com>
	<6540c930904232000t76aa4954l4f5cee5bad64aacb@mail.gmail.com>
	<20090501091804.GB29466@ime.usp.br>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there anything that I can do right now? Just to remember, the
> original IDE driver works without any problems, but I would like to
> migrate everything to libata (and many distributions are already using
> libata by default, even with IDE devices).

At the moment I've not found a way to duplicate your specific problem.
Bartlomiej has certainly found one bug that needs fixing. I've actually
been working remotely on another box that had problems with the driver but
those seem different to yours and once I've run a couple of final tests
I'll need to talk to Tejun about some EH tweaks. That bug however appears
specific to a faulty disk and while it looks similar I see no evidence of
you having any bad sectors.

