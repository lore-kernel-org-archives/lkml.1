Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbZKYR5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbZKYR5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbZKYR5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:57:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54960 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758188AbZKYR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:57:35 -0500
Date: Wed, 25 Nov 2009 17:59:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/86] pata_artop: add 32-bit PIO support
Message-ID: <20091125175941.56a6f52d@lxorguk.ukuu.org.uk>
In-Reply-To: <200911251818.18521.bzolnier@gmail.com>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170239.5446.26287.sendpatchset@localhost>
	<20091125171242.70b8019f@lxorguk.ukuu.org.uk>
	<200911251818.18521.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:18:18 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 25 November 2009 06:12:42 pm Alan Cox wrote:
> > On Wed, 25 Nov 2009 18:02:39 +0100
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] pata_artop: add 32-bit PIO support
> > > 
> > > There shouldn't be any problems with it as IDE aec62xx host driver
> > > has been allowing 32-bit PIO operations for years.
> > 
> > Allowing or defaulting too ?
> 
> For aec62xx: allowing, for some other drivers: defaulting ('using'
> in the patch description instead of 'allowing').  However some
> popular distributions have been defaulting to always enabling it
> if was supported by the driver.

I wonder what their coverage of old devices is like though and what they
enabled. No problem with those that defaulted, would be nice to get the
rest tested more systematically
