Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbYBHO7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbYBHO7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 09:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYBHO7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 09:59:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111AbYBHO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 09:59:19 -0500
Date: Fri, 8 Feb 2008 09:59:11 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, Theodore Tso <tytso@MIT.EDU>,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3 freeze feature
Message-ID: <20080208145911.GA4257@infradead.org>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp> <20080208132657.GE3120@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208132657.GE3120@webber.adilger.int>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 08:26:57AM -0500, Andreas Dilger wrote:
> You may as well make the common ioctl the same as the XFS version,
> both by number and parameters, so that applications which already
> understand the XFS ioctl will work on other filesystems.

Yes.  In facy you should be able to lift the implementations of
XFS_IOC_FREEZE and XFS_IOC_THAW to generic code, there's nothing
XFS-specific in there.

