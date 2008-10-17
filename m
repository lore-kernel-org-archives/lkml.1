Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYJQLdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYJQLdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYJQLdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:33:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38296 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYJQLdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:33:10 -0400
Date: Fri, 17 Oct 2008 05:32:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Greg KH <greg@kroah.com>, Joel Becker <joel.becker@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       SCST-Devel <scst-devel@lists.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct kobject source.
Message-ID: <20081017113252.GV15064@parisc-linux.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org> <20081017074453.GA4850@kroah.com> <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> This of course means that non TYPE_DISK of struct scsi_device would need
> to appear under /sys/ to be referenced using the symlink method..  I
> know that drivers/scsi/sr.c currently does not show up under /sys..

Hmm?

$ ls -l /sys/block/sr0/
total 0
lrwxrwxrwx 1 root root    0 2008-10-17 07:30 bdi -> ../../class/bdi/11:0
-r--r--r-- 1 root root 4096 2008-10-17 07:30 capability
-r--r--r-- 1 root root 4096 2008-10-17 07:30 dev
lrwxrwxrwx 1 root root    0 2008-10-17 07:30 device -> ../../devices/pci0000:00/0000:00:1f.1/host3/target3:0:0/3:0:0:0
drwxr-xr-x 2 root root    0 2008-10-17 07:30 holders
drwxr-xr-x 2 root root    0 2008-10-17 07:30 power
drwxr-xr-x 3 root root    0 2008-10-17 07:30 queue
-r--r--r-- 1 root root 4096 2008-10-17 07:30 range
-r--r--r-- 1 root root 4096 2008-10-17 07:30 removable
-r--r--r-- 1 root root 4096 2008-10-17 07:30 ro
-r--r--r-- 1 root root 4096 2008-10-17 07:30 size
drwxr-xr-x 2 root root    0 2008-10-17 07:30 slaves
-r--r--r-- 1 root root 4096 2008-10-17 07:30 stat
lrwxrwxrwx 1 root root    0 2008-10-17 07:30 subsystem -> ../../block
-rw-r--r-- 1 root root 4096 2008-10-17 07:30 uevent

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
