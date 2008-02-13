Return-Path: <linux-kernel-owner+w=401wt.eu-S1764397AbYBMATN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764397AbYBMATN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbYBMASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:18:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59745 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbYBMASk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:18:40 -0500
Date: Tue, 12 Feb 2008 16:16:38 -0800
From: Greg KH <greg@kroah.com>
To: muli@il.ibm.com, jdmason@kudzu.us
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213001638.GB13933@kroah.com>
References: <20080213001506.GA13933@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213001506.GA13933@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:15:06PM -0800, Greg KH wrote:
> Hi,
> 
> I'm reworking the pci device list logic (we currently keep all PCI
> devices in 2 lists, which isn't the nicest, we should be able to get
> away with only 1 list.)
> 
> The only bother I've found so far is the pci_get_device_reverse()
> function, it's used in 2 places, IDE and the calgary driver.

Why does the calgary driver need this?  Can we just use pci_get_device()
instead?  Why do you need to walk the device list backwards?  Do you get
false positives going forward?

thanks,

greg k-h
