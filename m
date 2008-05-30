Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbYE3ESK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbYE3ESK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761527AbYE3ERK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:17:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:45600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761206AbYE3ERI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:17:08 -0400
Date: Thu, 29 May 2008 21:15:28 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [GIT PATCH] driver core patch against 2.6.26-rc4
Message-ID: <20080530041528.GA13743@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a single patch against your 2.6.26-git tree.

It was suggested by Stephen, as it will help with the linux-next merge
issues starting to happen as this api changes in anticipation for
2.6.27.  This patch merges a functional version of the dev_set_name()
function for other trees to be able to take adnd merge in changes that
help with the progression toward getting rid of the bus_id field and the
limitation of 20 characters for the name of struct device.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

The patch will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/core.c    |   15 +++++++++++++++
 include/linux/device.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

---------------

Stephen Rothwell (1):
      driver-core: prepare for 2.6.27 api change by adding dev_set_name

