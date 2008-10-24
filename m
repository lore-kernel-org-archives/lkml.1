Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYJXQKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYJXQKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYJXQKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:10:01 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:41808 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbYJXQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:10:00 -0400
Message-ID: <4901F349.3020406@csr.com>
Date: Fri, 24 Oct 2008 17:09:45 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] single UWB fix for 2.6.28-rc1
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Oct 2008 16:09:45.0419 (UTC) FILETIME=[EE5CD9B0:01C935F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull this single change to fix an oops if CONFIG_USB_WHCI_HCD=y
(instead of n or m).

  git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

David Vrabel (2):
      uwb: build UWB before USB/WUSB
      Merge branch 'master' into for-upstream

 drivers/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I'm guessing you don't really want that 'Merge branch...' commit.  I
should read up on using remote-tracking branches.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
