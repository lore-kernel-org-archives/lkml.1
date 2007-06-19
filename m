Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXFSIQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXFSIQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXFSIQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:16:25 -0400
Received: from verein.lst.de ([213.95.11.210]:38697 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbXFSIQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:16:24 -0400
Date: Tue, 19 Jun 2007 10:15:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Miller <davem@davemloft.net>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, axboe@kernel.dk,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org,
       Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Message-ID: <20070619081546.GA25336@lst.de>
References: <1181947242.3600.8.camel@mulgrave.il.steeleye.com> <20070615.160858.26276547.davem@davemloft.net> <20070619055629.GE18542@lst.de> <20070618.230731.11645150.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618.230731.11645150.davem@davemloft.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:07:31PM -0700, David Miller wrote:
> The main disk I/O block read and write is done using descriptors
> sent to the disk server.  SCSI pass-through is provided (optionally)
> so that disk analysis tools can do things like MODE_SENSE on the
> disk.

SG_IO can easily be implemented for block devices.  See cciss in
current mainline for an example.
