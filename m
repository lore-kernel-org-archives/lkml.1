Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbZKRTAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbZKRTAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbZKRTAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:00:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35601 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311AbZKRTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:00:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 18 Nov 2009 20:00:18 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/6] DVB: firedtv: simplifications and a portability fix
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches are applicable after "firedtv: port to new
firewire core" from 2009-11-08:

[PATCH 1/6] firedtv: shrink buffer pointer table
[PATCH 2/6] firedtv: packet requeuing is likely to succeed
[PATCH 3/6] firedtv: remove an unnecessary function argument

The rest of this patch set additionally requires the latest firedtv as
of 2.6.32-rc7:

[PATCH 4/6] firedtv: do not DMA-map stack addresses
[PATCH 5/6] firedtv: remove check for interrupting signal
[PATCH 6/6] firedtv: reduce memset()s

 drivers/media/dvb/firewire/firedtv-1394.c |   13
 drivers/media/dvb/firewire/firedtv-avc.c  |  520 +++++++++++-----------
 drivers/media/dvb/firewire/firedtv-dvb.c  |    1
 drivers/media/dvb/firewire/firedtv-fw.c   |   39 -
 drivers/media/dvb/firewire/firedtv.h      |    8
 5 files changed, 306 insertions(+), 275 deletions(-)
-- 
Stefan Richter
-=====-==--= =-== =--=-
http://arcgraph.de/sr/

