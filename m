Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbYBBBv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbYBBBv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761853AbYBBBve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:51:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64273 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760986AbYBBBvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:51:32 -0500
Message-ID: <47A3CC70.8090900@cn.fujitsu.com>
Date: Sat, 02 Feb 2008 09:50:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: linux-2.6.24 compile error in drivers/net/b44.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/net/b44.c: In function 'b44_remove_one':
drivers/net/b44.c:2231: error: implicit declaration of function 'ssb_pcihost_set_power_state'
make[2]: *** [drivers/net/b44.o] Error 1
make[1]: *** [drivers/net] Error 2

I think it is caused by:

CONFIG_SSB_PCIHOST=n
CONFIG_B44=y

