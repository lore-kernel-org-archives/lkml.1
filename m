Return-Path: <linux-kernel-owner+w=401wt.eu-S1751044AbXCZUgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbXCZUgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXCZUgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:36:01 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:50703 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044AbXCZUgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:36:00 -0400
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070326200257.GA28622@infradead.org>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
	 <4607CA5A.4040906@s5r6.in-berlin.de> <20070326200257.GA28622@infradead.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 15:35:47 -0500
Message-Id: <1174941347.3549.41.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 21:02 +0100, Christoph Hellwig wrote:
> > >   it would seem to make no sense that the "depends on" clause for this
> > > option includes "m", forcing this (and all other four entries in that
> > > Kconfig file, by the way) to be built as modules, while the help text
> > > for all five entries suggests you can select "y".
> 
> In the old days pcmcia drivers had to be modular because pcmcia required
> a lot of userspace setup.  It's not needed anymore these days and the
> dependencies can go.

I agree the non-legacy (CardBus and beyond) ones can be built in.  I
thought the legacy 8 and 16 bit type I and II still had to be modular
because they still need setting up.

James


