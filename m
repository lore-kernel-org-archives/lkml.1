Return-Path: <linux-kernel-owner+w=401wt.eu-S1764820AbYBMASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764820AbYBMASy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759942AbYBMASl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:18:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59743 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbYBMASk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:18:40 -0500
Date: Tue, 12 Feb 2008 16:15:07 -0800
From: Greg KH <greg@kroah.com>
To: bzolnier@gmail.com
Cc: muli@il.ibm.com, jdmason@kudzu.us, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: "ide=reverse" do we still need this?
Message-ID: <20080213001506.GA13933@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm reworking the pci device list logic (we currently keep all PCI
devices in 2 lists, which isn't the nicest, we should be able to get
away with only 1 list.)

The only bother I've found so far is the pci_get_device_reverse()
function, it's used in 2 places, IDE and the calgary driver.

I'm curious if we really still support the ide=reverse option?  It's a
config option that I don't think the distros still enable (SuSE does
not).  Is this still needed these days?

In digging, we changed this option in 2.2.x from being called
"pci=reverse" and no one else seems to miss it.

Any thoughts?

thanks,

greg k-h
