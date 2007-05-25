Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbXEYWp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbXEYWp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXEYWpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:45:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:58023 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbXEYWpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:45:50 -0400
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: Geert.Uytterhoeven@sonycom.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070525112414.GA32336@aepfle.de>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.677742000@sonycom.com>  <20070525112414.GA32336@aepfle.de>
Content-Type: text/plain
Date: Sat, 26 May 2007 08:45:19 +1000
Message-Id: <1180133119.19517.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 13:24 +0200, Olaf Hering wrote:
> On Fri, May 25, Geert.Uytterhoeven@sonycom.com wrote:
> 
> > +++ b/drivers/scsi/ps3rom.c
> 
> > +			kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> 
> linux/highmem.h is not included to get the kmap_* prototypes.

Beside, I don't see the point of using kmap on ppc64...

Ben.


