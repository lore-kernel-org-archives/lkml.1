Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZBPPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZBPPAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZBPPA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:00:29 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:48866 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZBPPA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:00:28 -0500
Message-ID: <49997F7A.6040900@csr.com>
Date: Mon, 16 Feb 2009 15:00:10 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [git pull] WUSB: single lockdep fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2009 15:00:10.0062 (UTC) FILETIME=[43292EE0:01C99047]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull this single fix for a lockdep error.

The following changes since commit d2f8d7ee1a9b4650b4e43325b321801264f7c37a:
  Linus Torvalds (1):
        Linux 2.6.29-rc5

are available in the git repository at:


git+ssh://dvrabel@master.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git
for-upstream

David Vrabel (1):
      wusb: whci-hcd: always lock whc->lock with interrupts disabled

 drivers/usb/host/whci/asl.c |    4 ++--
 drivers/usb/host/whci/pzl.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
