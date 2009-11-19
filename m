Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZKSPUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZKSPUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZKSPUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:20:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44201 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbZKSPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:20:48 -0500
Date: Thu, 19 Nov 2009 15:22:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119152245.479dc38d@lxorguk.ukuu.org.uk>
In-Reply-To: <200911191550.25476.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<200911191517.15090.bzolnier@gmail.com>
	<20091119143351.1d0e2c59@lxorguk.ukuu.org.uk>
	<200911191550.25476.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you know about other drivers still using ->pre_reset for cable detection
> please let us know because they need fixing ASAP.
> 
> ->cable_detect method is there for a reason,

Given that I added it I may know more about it than you do. In fact from
the rubbish you spout below it seems I do.

> already have a buggy cable detection (since ->pre_reset ignores the mandatory

Wrong.

> by spec part of cable detection which is probing slave before master) and

Have a free hint. If the host detects the cable type then we don't ask
the drive. See the standard if you don't understand why. Even if we
didn't the code would still be correct because we properly evaluate
the speed configuration from all the data sources.

> make it more likely to cause breakages in the future when some other developer
> do a change under assumption that all host drivers use API correctly.

To quote Bartlomiej "Talk to the maintainer" (or use grep).

Alan

