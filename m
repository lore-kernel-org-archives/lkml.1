Return-Path: <linux-kernel-owner+w=401wt.eu-S1767000AbXDEOJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767000AbXDEOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766999AbXDEOJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:09:27 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:38368 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766997AbXDEOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:09:25 -0400
Subject: Re: [PATCH] Perverting cciss
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Mike Miller <mike.miller@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
In-Reply-To: <20070405100326.GA19092@infradead.org>
References: <4614C82E.1020100@suse.de>
	 <20070405100326.GA19092@infradead.org>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 09:09:10 -0500
Message-Id: <1175782151.3714.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 11:03 +0100, Christoph Hellwig wrote:
> On Thu, Apr 05, 2007 at 11:58:06AM +0200, Hannes Reinecke wrote:
> > Hi All,
> > 
> > this patch adds the SG_IO ioctl to the cciss driver.
> > As the driver is capable of sending SCSI CDBs to the controller there is
> > no reason why we shouldn't exploit it.
> > This way we get to use all the nice sg_utils for the cciss driver.
> > And a persistent device name for free.
> 
> Instead of adding yet another implementation of SG_IO please implement
> support for REQ_TYPE_BLOCK_PC requests and add all the nice block layer
> passthrough ioctls to it.

Actually, I happen to know that HP is in the process of implementing
this correctly (via REQ_TYPE_BLOCK_PC).  I can't reveal the details but
it has something to do with a well known Linux High Availability company
needing SG_IO for sg_persist to work ...

James


