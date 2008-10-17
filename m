Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYJQHqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYJQHqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 03:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYJQHqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 03:46:24 -0400
Received: from kroah.org ([198.145.64.141]:58515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751605AbYJQHqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 03:46:22 -0400
Date: Fri, 17 Oct 2008 00:44:53 -0700
From: Greg KH <greg@kroah.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       SCST-Devel <scst-devel@lists.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Message-ID: <20081017074453.GA4850@kroah.com>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> Hi Joel, Greg and Co,
> 
> Here is the the first working code for allowing configfs to handle
> symlinks from sysfs struct kobject based code.  Here is the commit:
> passing struct kobject into generic target_core_mod subsystem plugins
> for locating struct block_device and struct scsi_device..  

Um, no.

You are trying to create symlinks dynamically across superblocks and
mount points?  As one of your #warning states, this isn't possible to do
correctly, nor is it even a good idea.

So I'd have to reject this patch, sorry.

What is the problem you are attempting to solve here?

thanks,

greg k-h
