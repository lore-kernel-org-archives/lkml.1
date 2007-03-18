Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXCRUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXCRUJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXCRUJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:09:36 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:32393 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbXCRUJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:09:34 -0400
Message-ID: <45FD9C76.3040503@chelsio.com>
Date: Sun, 18 Mar 2007 12:09:26 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.21 0/4] cxgb3 - bug fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2007 20:09:29.0643 (UTC) FILETIME=[55F5BFB0:01C76999]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a set of bug fixes for inclusion in 2.6.21.
The patches are built against Linus'git tree.

Here is a brief description:
- ethtool -g/G should only apply to queue sets bound to the given port,
- the driver will attempt to load the FW if it hits a version mismatch,
- monitor the MAC for a potential hang, and triggers a recovery mechanism
  for the T3B2 asic ,
- T3B2 does not lose its pcie config space on reset.

Cheers,
Divy
