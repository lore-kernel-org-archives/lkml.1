Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYAZQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYAZQlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYAZQlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:41:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58012 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYAZQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:41:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Jan 2008 17:40:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/3] some more firewire-sbp2 work
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Message-ID: <tkrat.1198d1dd6ae8d623@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here come one triviality and two fixes, or at least attempts to do so.
I tried but couldn't recreate the conditions to put patch 2/3 into
effect.  But I did so with patch 3/3; that's easier due to a larger
window where this problem can happen.

1/3 firewire: fw-sbp2: unsigned int vs. unsigned
2/3 firewire: fw-sbp2: fix logout before login retry
3/3 firewire: fw-sbp2: retry login if scsi_device was offlined early

 drivers/firewire/fw-sbp2.c |   52 +++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 13 deletions(-)
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/

