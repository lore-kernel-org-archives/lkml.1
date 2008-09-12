Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYILCNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYILCNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYILCNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:13:22 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57831 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbYILCNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:13:21 -0400
Message-ID: <48C9D040.8010107@lwfinger.net>
Date: Thu, 11 Sep 2008 21:13:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: I need help with a sparse warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file drivers/net/wireless/p54/p54common.c, the statement

        priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);

generates the sparse warning

.../p54common.c:185:29: warning: cast to restricted __le16

where bootrec->data is u32, and priv->rx_mtu is u16.

What should be done to eliminate this warning?

Thanks,

Larry

