Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0BKQfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:35:05 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:59122 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab0BKQfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:35:01 -0500
Message-ID: <4B7431A8.9010902@free.fr>
Date: Thu, 11 Feb 2010 17:34:48 +0100
From: Bernard Pidoux <bpidoux@free.fr>
User-Agent: Thunderbird 2.0.0.23 (X11/20100108)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] net: ax25: use seq_hlist_foo() helpers
References: <4B2E6729.1090102@free.fr>	<4B507FAA.8010007@free.fr>	<20100115203654.GA3084@del.dom.local> <20100116.010435.55169828.davem@davemloft.net>
In-Reply-To: <20100116.010435.55169828.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li Zefan,

Your patches 1, 2, 3, 4, 6, 7, 9, 10/13 applied.
kernel and modules compiled ok.
AX25 and ROSE are working fine.

Thanks.

Bernard


Simplify seq_file code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/ax25/af_ax25.c  |   18 +++---------------
 net/ax25/ax25_uid.c |   25 ++++---------------------
 2 files changed, 7 insertions(+), 36 deletions(-)

