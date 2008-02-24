Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYBXFb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYBXFb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYBXFbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:31:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYBXFbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:31:18 -0500
Date: Sun, 24 Feb 2008 00:31:17 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [SCSI] gdth: misc cleanups, preparation for
	ISA/EISA hotplug API
Message-ID: <20080224053117.GA13904@infradead.org>
References: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org> <20080224045810.GA17051@infradead.org> <47C0FE1F.300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C0FE1F.300@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 12:18:23AM -0500, Jeff Garzik wrote:
> hmmmmm.  We'll see how it plays out...  on the remove side, the above is 
> exact what happens in gdth_remove_one() without my patch, thus 
> consolidating two cases of the same code into one.  There is a less-strong 
> argument for doing the allocation that way, but it may turn out to be 
> useful anyway once the ISA/EISA API conversion is complete.

EISA ->remove has a different prototype from PCI ->remove from ISA
->remove, so gdth_remove_one will be split up eventually.  Having the
scsi_host_put duplicated in each shouldn't be too much of a problem :)

