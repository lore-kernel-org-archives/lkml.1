Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbXH3CP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbXH3CP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 22:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbXH3CPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 22:15:14 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:8685 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbXH3CPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 22:15:12 -0400
Message-ID: <46D62823.5000504@chelsio.com>
Date: Wed, 29 Aug 2007 19:14:59 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Roland Dreier <rdreier@cisco.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.23 0/2] cxgb3 driver fixes 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2007 02:13:37.0469 (UTC) FILETIME=[60066ED0:01C7EAAB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

I'm resubmitting the cxgb3 dev->priv issue.
I'm also submitting a patch fixing the engine microcode loading.

The first patch changes in both cxgb3 and iw_cxgb3 related to
the dev->priv issue.
The second patch allows the driver to load the engine microcode
at the right time - when a port is brought up as opposed to
the module getting loaded. It does a better job at logging
the loading activity, and loosen the strict version requirement
currently in place.

Cheers,
Divy

