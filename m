Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZI2M7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZI2M7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZI2M7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:59:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZI2M7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:59:22 -0400
Date: Tue, 29 Sep 2009 14:56:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
Message-ID: <20090929125657.GA26932@redhat.com>
References: <20090929103353.GA11183@redhat.com> <20090929124347.GA11375@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929124347.GA11375@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 08:43:47AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 29, 2009 at 12:33:53PM +0200, Michael S. Tsirkin wrote:
> > This implements a minor cleanup of exported scsi headers,
> > and adds export of headers that are de-facto used by userspace.
> > The patches are on top of 2.6.32-rc1.
> > Can these be queued for 2.6.32?
> > Thanks.
> 
> Before we do anything in this area we need to find an agreement who
> owns /usr/include/scsi/ .

Let's cleanup headers that we already export (that's patches 1/2 in the
series).  I don't see a reason to delay that, do you?

> Right now that's glibc, and if we want to
> change it to the kernel headers we need to find a transition agreement
> with the glibc maintainer (aka mostly Uli).

Who cares? If glibc wants to carry its own headers, let it.  It will
likely switch if what kernel provides is sane (it is currently not). So
let's start with cleaning up what we already have.  If glibc decides not
to use it, no harm's done.

> And even then it's quite questionable if the kernel should provide
> scsi.h as it's mostly protocol defintions, not actually a kernel
> interface.

It has a ton of ioctl definitions there.

-- 
MST
