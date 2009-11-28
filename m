Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZK1AuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZK1AuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 19:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZK1AuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 19:50:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39081 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZK1AuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 19:50:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 28 Nov 2009 01:50:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.1f2318b5dacd8c9e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive fixes for two bugs which prevented FireWire audio drivers in
userspace (FFADO) to run on the newer firewire kernel stack.

This affects very specific functionality only (necessary for audio out)
and has been extensively tested already, hence I consider this good to
pull even this late.

Jay Fenlason (2):
      firewire: ohci: Make cycleMatch ISO transmission work
      firewire: ohci: pass correct iso xmit timestamps to core

 drivers/firewire/ohci.c |   41 +++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 6 deletions(-)

Thanks.
-- 
Stefan Richter
-=====-==--= =-== ===--
http://arcgraph.de/sr/

