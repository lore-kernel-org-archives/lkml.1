Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0BNRpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:45:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41346 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0BNRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:45:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Feb 2010 18:44:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire: a hardware quirk workaround and related bits
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following in replies:

[PATCH 1/4 resend] firewire: ohci: work around cycle timer bugs on VIA controllers
[PATCH 2/4] firewire: ohci: enable cycle timer fix on ALi and NEC controllers
[PATCH 3/4] firewire: get_cycle_timer optimization and cleanup
[PATCH 4/4] firewire: remove incomplete Bus_Time CSR support

 firewire/core-cdev.c        |   17 +++----
 firewire/core-transaction.c |   17 ++-----
 firewire/core.h             |    2
 firewire/ohci.c             |   83 ++++++++++++++++++++++++++----------
 4 files changed, 75 insertions(+), 44 deletions(-)
-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/

