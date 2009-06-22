Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZFVRKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZFVRKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZFVRKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:10:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42887 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753417AbZFVRKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:10:36 -0400
Date: Mon, 22 Jun 2009 18:11:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
       David Miller <davem@davemloft.net>, bzolnier@gmail.com,
       elendil@planet.nl, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared -
 system 	is dreadfully slow)
Message-ID: <20090622181100.43a56309@lxorguk.ukuu.org.uk>
In-Reply-To: <4A3FB956.6060401@garzik.org>
References: <20090621.141950.160759111.davem@davemloft.net>
	<200906220034.22430.bzolnier@gmail.com>
	<20090621.155756.100422570.davem@davemloft.net>
	<20090621.161343.181101055.davem@davemloft.net>
	<87f94c370906212039sa23d49fh305d8f0d58a48d1f@mail.gmail.com>
	<4A3FB956.6060401@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are a handful of IDE drivers not yet ported over to libata, all 
> !x86 drivers; maybe there's an odd ARM platform or two in there, I 
> haven't checked recently.

There are several drivers that are not supported in libata (and several
only in libata, and several that work better in one than the other for
reasons nobody can figure sometimes)

Biggest legacy hanger on is the older PowerMac boxes because both people
who planned to do the driver had the mac they were using simply die of
old age on them.

sgiioc4 is another obvious "modern machine" case. The rest are pretty
obscure (eg mac68K drivers and IDE VLB drivers most of which don't
actually work in the old IDE code even though there is code)

