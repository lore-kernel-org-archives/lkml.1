Return-Path: <linux-kernel-owner+w=401wt.eu-S1761899AbYEGCk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761899AbYEGCk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbYEGCkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:40:01 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:28306 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbYEGCje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:39:34 -0400
X-Greylist: delayed 809 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 22:39:32 EDT
Message-ID: <48211331.8010400@chelsio.com>
Date: Tue, 06 May 2008 19:25:53 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: NetDev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/2 2.6.26] cxgb3 - EEH fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2008 02:25:18.0312 (UTC) FILETIME=[9771D680:01C8AFE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a patch series for inclusion in 2.6.26.
The patches are built against Linus'tree.

The first patch fixes the error path if EEH does not recover the adapter.
The second patch guarantees that the chip is reset when EEh detects a 
pci error,
and fixes the recovery.

Cheers,
Divy
