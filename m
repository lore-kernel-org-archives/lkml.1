Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYAZUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYAZUXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYAZUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:23:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYAZUXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:23:04 -0500
Date: Sat, 26 Jan 2008 20:22:47 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, neilb@suse.de,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] block: look up block device path in sysfs
Message-ID: <20080126202246.GB28444@infradead.org>
References: <20080126050313.3756.13442.stgit@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126050313.3756.13442.stgit@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 10:04:51PM -0700, Dan Williams wrote:
> Given an fd on a block device, returns a string like
> 
> 	/block/sda/sda1
> 
> which can be used to find related information in /sys.
> 
> Ideally we should have an ioctl that works on char devices as well,
> but that seems far from trivial, so it seems reasonable to have
> this until the latter can be implemented.

What did you do to address Viro's reasonable rejection of this when
it came up last time?

