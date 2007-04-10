Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbXDJDKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbXDJDKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXDJDKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:10:06 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:23640 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbXDJDKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:10:05 -0400
Message-ID: <461B0005.7070801@chelsio.com>
Date: Mon, 09 Apr 2007 20:09:57 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.21 0/3] cxgb3 - bug fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2007 03:09:59.0449 (UTC) FILETIME=[B92F2090:01C77B1D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'm submitting a set of bug fixes for inclusion in 2.6.21.
The patches are built against Linus'git tree.

Here is a brief description:
- Avoid deadlock when the interface is brought down
- Rework the MAC hang workaround since it was failing
  if the peer interface was brought down
- add missing RNIC register setting and CPL handler

Cheers,
Divy
