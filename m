Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZFEUOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZFEUOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZFEUOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:14:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53320 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751960AbZFEUOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:14:11 -0400
Date: Fri, 5 Jun 2009 21:15:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Yunpeng Gao <yunpeng.gao@intel.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for June 3 (staging)
Message-ID: <20090605211520.5846fbb8@lxorguk.ukuu.org.uk>
In-Reply-To: <200906052045.49610.bzolnier@gmail.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
	<20090603231152.GA18701@suse.de>
	<20090604232610.GA16053@intel.com>
	<200906052045.49610.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +menuconfig MRST_NAND
> > +	tristate "Moorestown NAND Flash controller"
> > +	depends on BLOCK
> > +	default m
> 
> New drivers shouldn't be enabled by default.

I think that rather depends on the driver - in this case I'd tend to
agree as its not a common standard PC driver.
