Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbXIZVQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbXIZVQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763272AbXIZVQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:16:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41781 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763263AbXIZVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:16:00 -0400
Date: Wed, 26 Sep 2007 14:10:57 -0700
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
Message-ID: <20070926211057.GA3050@kroah.com>
References: <20070926184652.GA16369@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926184652.GA16369@andromeda.dapyr.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 02:46:52PM -0400, Konrad Rzeszutek wrote:
> This patch adds a /sysfs/firmware/ibft/table binary blob which exports
> the iSCSI Boot Firmware Table (iBFT) structure. 

Please don't do that.  Binary files are for things that are
"pass-through" only, not anything that the kernel knows the structure
of, or cares about (like PCI config space, or firmware blobs for
devices.)

Just export the individual fields of this table as individual files
please.

thanks,

greg k-h
