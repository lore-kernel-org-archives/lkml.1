Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbXGESEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbXGESEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXGESEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:04:33 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:49205 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbXGESEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:04:32 -0400
Date: Thu, 5 Jul 2007 12:04:28 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070705180428.GJ5633@schatzie.adilger.int>
Mail-Followup-To: Mike Frysinger <vapier@gentoo.org>,
	Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
	List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070703221156.GY14825@petra.dvoda.cz> <20070704084211.GA19128@infradead.org> <200707051242.00625.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707051242.00625.vapier@gentoo.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 05, 2007  12:41 -0400, Mike Frysinger wrote:
> On Wednesday 04 July 2007, Christoph Hellwig wrote:
> > Sorry, but it's really annoying to pull in a filesystem-specific devel
> > package for that.  Having a library is fine, but please move the library
> > into util-linux so it's always available without another dependency.
> 
> ugh, moving libraries which are already actively maintained by other core 
> projects into util-linux is so not a good idea (ignoring the fact that it'd 
> easily be a pita/waste for distro maintainers)

Some distros (Debian and SuSE I think) split the e2fsprogs libraries
into separate packages so that you are not depending on "e2fsprogs",
but rather "libuuid" and/or "libblkid".

> > That way xfsprogs could for example drop it's own detection library aswell.
> 
> i dont really think this is dependent on util-linux at all.  nothing is 
> stopping xfsprogs from depending on udev or e2fsprogs now.

In fact, Eric Sandeen and I discussed splitting the xfsprogs "libdisk"
(or similar, it detects RAID geometry for DM/MD/etc) into a standalone
library so that e2fsprogs could use it.  The only issue is the increased
maintenance and packaging of separate libraries.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

