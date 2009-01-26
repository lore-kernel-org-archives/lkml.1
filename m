Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZAZRnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZAZRnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZAZRm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:42:59 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:5778 "EHLO
	stargate.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752000AbZAZRm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:42:58 -0500
Message-ID: <497DF609.9000600@chelsio.com>
Date: Mon, 26 Jan 2009 09:42:33 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>
CC: Linux Network Development list <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2 2.6.30] cxgb3 - notify iWARP of chip resets
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2009 17:43:08.0328 (UTC) FILETIME=[8CC96A80:01C97FDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, Roland,

I'm submitting 2 patches against cxgb3 and iw_cxgb3 respectively.
They are built against net-next-2.6.
The first patch adds a notification mechanism to cxgb3 to alert
the upper layer drivers (iWARP and iSCSI) of a chip reset.

The second patch adds the handler for such an event in the iWARP driver.

Since the second patch depends on the first one, I submit them together,
even though the second patch should be submitted against Roland's tree.

Cheers,
Divy

