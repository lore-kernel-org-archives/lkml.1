Return-Path: <linux-kernel-owner+w=401wt.eu-S1765109AbXE2Lco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765109AbXE2Lco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760387AbXE2Lcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:32:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:54993 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbXE2Lce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:32:34 -0400
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.677742000@sonycom.com> <20070529104948.GC29351@lst.de>
	 <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
Content-Type: text/plain
Date: Tue, 29 May 2007 21:31:59 +1000
Message-Id: <1180438319.19517.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 13:11 +0200, Geert Uytterhoeven wrote:
> > This looks very inefficient.  Just set sg_tablesize of your driver
> > to 1 to avoid getting mutiple segments.
> 
> The disadvantage of setting sg_tablesize = 1 is that the driver will
> get small
> requests (PAGE_SIZE) most of the time, which is very bad for
> performance.

And the joke is that not only the HW can do scatter & gather but you
also have an iommu ...

Ben.


