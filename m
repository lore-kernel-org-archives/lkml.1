Return-Path: <linux-kernel-owner+w=401wt.eu-S1764523AbYBMGDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764523AbYBMGDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765438AbYBMGCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:02:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60067 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765392AbYBMGCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:02:20 -0500
Date: Tue, 12 Feb 2008 20:45:36 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: muli@il.ibm.com, jdmason@kudzu.us, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213044536.GC10101@kroah.com>
References: <20080213001506.GA13933@kroah.com> <20080213001638.GB13933@kroah.com> <20080213021737.72b9815d@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213021737.72b9815d@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:17:37AM +0000, Alan Cox wrote:
> > Why does the calgary driver need this?  Can we just use pci_get_device()
> > instead?  Why do you need to walk the device list backwards?  Do you get
> > false positives going forward?
> 
> It doesn't look to be performance critical so the driver can
> pci_get_device until the end and use the final hit anyway.

That would make more sense.

> IDE reverse is more problematic but nobody seems to use it.

I've seen two posters say they use it.  I'm wondering what it is really
solving if they use it, and why if it's really needed, scsi never had to
implement such a hack...

thanks,

greg k-h
