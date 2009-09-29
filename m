Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZI2Mns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZI2Mns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZI2Mnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:43:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZI2Mnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:43:46 -0400
Date: Tue, 29 Sep 2009 08:43:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
Message-ID: <20090929124347.GA11375@infradead.org>
References: <20090929103353.GA11183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929103353.GA11183@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 12:33:53PM +0200, Michael S. Tsirkin wrote:
> This implements a minor cleanup of exported scsi headers,
> and adds export of headers that are de-facto used by userspace.
> The patches are on top of 2.6.32-rc1.
> Can these be queued for 2.6.32?
> Thanks.

Before we do anything in this area we need to find an agreement who
owns /usr/include/scsi/ .  Right now that's glibc, and if we want to
change it to the kernel headers we need to find a transition agreement
with the glibc maintainer (aka mostly Uli).

And even then it's quite questionable if the kernel should provide
scsi.h as it's mostly protocol defintions, not actually a kernel
interface.

