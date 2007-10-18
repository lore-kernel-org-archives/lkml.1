Return-Path: <linux-kernel-owner+w=401wt.eu-S1765485AbXJRQTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765485AbXJRQTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762649AbXJRQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:19:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:52922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765288AbXJRQTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:19:04 -0400
Date: Thu, 18 Oct 2007 09:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git12: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Message-ID: <20071018160829.GE13346@suse.de>
References: <4716F134.2060002@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4716F134.2060002@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 01:37:56AM -0400, Mark Lord wrote:
>
> usb 5-1: new high speed USB device using ehci_hcd and address 2
> usb 5-1: configuration #1 chosen from 1 choice
> hub 5-1:1.0: USB hub found
> hub 5-1:1.0: 4 ports detected
> sysfs: duplicate filename 'bInterfaceNumber' can not be created

Known issue, people are working on it, there's already a proposed patch
on lkml for this.

thanks,

greg k-h
