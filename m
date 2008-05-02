Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbYEBRQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbYEBRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYEBRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:16:17 -0400
Received: from ns.suse.de ([195.135.220.2]:51788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbYEBRQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:16:16 -0400
Date: Fri, 2 May 2008 10:15:50 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patch against 2.6.25-git
Message-ID: <20080502171550.GA25405@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one patch against your 2.6.25-git tree.

It provides a new function, dev_name() to help with the transition away
from using the bus_id field in struct device.  The full transision will
happen over the next few kernel releases.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

The patch will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 include/linux/device.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

---------------

Kay Sievers (1):
      driver-core: add dev_name() to help transition away from using bus_id

