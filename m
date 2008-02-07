Return-Path: <linux-kernel-owner+w=401wt.eu-S934130AbYBGAkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130AbYBGAkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbYBGALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:11:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:34382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbYBGALr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:11:47 -0500
Date: Wed, 6 Feb 2008 16:09:59 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080207000959.GA16601@suse.de>
References: <20080206233117.GA28931@suse.de> <20080206.153714.133821225.davem@davemloft.net> <20080206235902.GA15719@suse.de> <20080206.160231.45881964.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.160231.45881964.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 04:02:31PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Wed, 6 Feb 2008 15:59:02 -0800
> 
> > What block drivers are you using for sparc?  Scsi?  Or something else?
> > What could make sparc64 different from x86 in regards to block device
> > structure, odd...
> 
> Only Fusion SAS on this system, therefore scsi.

Can you send me the output of 'tree /sys/block/' on 2.6.24?

Are there a lot of partitions here?  Anything different you can think of
from x86 that I can have a chance to try to narrow things down with?  :)

I don't know if you can boot without udev, but if you could, can you
send the 'tree' output of the offending kernel too?

thanks,

greg k-h
