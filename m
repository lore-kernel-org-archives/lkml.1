Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbYBUAtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbYBUAtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbYBUAsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:48:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:40820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYBUAsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:48:47 -0500
Date: Wed, 20 Feb 2008 16:46:32 -0800
From: Greg KH <gregkh@suse.de>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
	Screen becomes green.
Message-ID: <20080221004632.GA25869@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <47BCAD6E.9080704@nigel.suspend2.net> <20080221001357.GA29796@srcf.ucam.org> <47BCC866.9000102@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BCC866.9000102@nigel.suspend2.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 11:40:06AM +1100, Nigel Cunningham wrote:
> Hi.
>
> Matthew Garrett wrote:
>> On Thu, Feb 21, 2008 at 09:45:02AM +1100, Nigel Cunningham wrote:
>>> - people keep talking about hibernating to an ext3 fs mounted on fuse as 
>>> a limitation of the freezer. To do that with kexec, you're still going to 
>>> have to bmap the ext3 fs and pass the block list (in which case we can 
>>> also do it without kexec) or umount all the ext3/fuse part and remount in 
>>> the kexec'd kernel. Sort of defeats the purpose, doesn't it?
>> No, with a freezer-based model you can basically *never* suspend to 
>> anything related to FUSE or a userspace USB device or anything involving 
>> userspace iSCSI initiators or whatever. Sure, there are cases where moving 
>> away from the current model doesn't buy you anything, but that doesn't 
>> mean that the current model is a good thing. It's not. The freezer is a 
>> fundamentally broken concept.
>
> Putting drivers and filesystems in userspace is the fundamentally broken 
> concept. Not just when it comes to the freezer. The whole idea is 
> inherently racy.

Racy with regards to other things becides trying to suspend a machine?
If so, what?

thanks,

greg k-h
