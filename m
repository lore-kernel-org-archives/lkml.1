Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYA1Spo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYA1Spo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYA1Spb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:45:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:38502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbYA1Sp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:45:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,260,1199692800"; 
   d="scan'208";a="372178596"
Subject: Re: [PATCH] block: look up block device path in sysfs
From: Dan Williams <dan.j.williams@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, neilb@suse.de,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <20080126202246.GB28444@infradead.org>
References: <20080126050313.3756.13442.stgit@dwillia2-linux.ch.intel.com>
	 <20080126202246.GB28444@infradead.org>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 11:43:59 -0700
Message-Id: <1201545839.25736.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-26 at 13:22 -0700, Christoph Hellwig wrote:
> On Fri, Jan 25, 2008 at 10:04:51PM -0700, Dan Williams wrote:
> > Given an fd on a block device, returns a string like
> >
> >       /block/sda/sda1
> >
> > which can be used to find related information in /sys.
> >
> > Ideally we should have an ioctl that works on char devices as well,
> > but that seems far from trivial, so it seems reasonable to have
> > this until the latter can be implemented.
> 
> What did you do to address Viro's reasonable rejection of this when
> it came up last time?

What was the objection?

My search only came up with a discussion about possibly making this a
generic capability for all devices:
http://marc.info/?t=118646704500006&r=1&w=2

Regards,
Dan

