Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXKNOSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXKNOSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXKNORy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:17:54 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:44864 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXKNORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:17:53 -0500
Date: Wed, 14 Nov 2007 07:17:51 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114141751.GS17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <p73sl39y6qb.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73sl39y6qb.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 02:07:56AM +0100, Andi Kleen wrote:
> It's not only complexity. Each new sysfs entry costs memory.
> Memory is not free. There should be always a good reason for those.

It's not a lot of memory; it's one directory and a couple of files for
each PCI slot in the system.  Even huge systems have maybe 200 slots.
In order for this to take up as much as one page of ram on a typical PC
with six slots, this would have to consume 680 bytes per directory.  I
don't think sysfs is that inefficient (and if it is, maybe this feature
is not where the problem is, given the 'power' directory per device, the
19 files per scsi device, the huge numbers of symlinks, etc).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
