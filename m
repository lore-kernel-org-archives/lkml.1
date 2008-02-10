Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYBJHMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYBJHMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYBJHMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:12:35 -0500
Received: from verein.lst.de ([213.95.11.210]:34280 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbYBJHMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:12:34 -0500
Date: Sun, 10 Feb 2008 08:12:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: dsdt@gaugusch.at, len.brown@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: acpi dsts loading and populate_rootfs
Message-ID: <20080210071226.GA23360@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, moving this call around hidden behing in completely unreviewed
acpi junk is not acceptable.

Either populate_rootfs _is_ safe to be called earlier and then we should
do it always or it's not.  Either way such a change should be posted
separately and reviewd on lkml.

Len, can you please revert "ACPI: basic initramfs DSDT override support"
aka commit 71fc47a9adf8ee89e5c96a47222915c5485ac437 until we've sorted
this out properly?  Thanks.
