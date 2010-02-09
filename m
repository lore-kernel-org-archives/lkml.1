Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab0BIJRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:17:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57993 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0BIJRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:17:51 -0500
Message-ID: <4B712849.9040400@cn.fujitsu.com>
Date: Tue, 09 Feb 2010 17:18:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 00/13] net: simplify seq_file code, revised
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces seq_hlist_foo() helpers, and convert
net/* to seq_hlist_foo() and seq_list_foo().

Changelog:

- Add kerneldoc in patch 1/13
- Fix compile warning in patch 11/13
- Fix a bug in patch 12/13

---
 fs/seq_file.c                 |   60 ++++++++++++++++++++-
 include/linux/seq_file.h      |   11 ++++
 include/net/sock.h            |    5 ++
 net/appletalk/atalk_proc.c    |   30 +----------
 net/atm/proc.c                |    2 +-
 net/atm/resources.c           |   28 +++--------
 net/ax25/af_ax25.c            |   18 +-----
 net/ax25/ax25_uid.c           |   25 ++--------
 net/ipx/ipx_proc.c            |   90 ++++----------------------------
 net/irda/irlan/irlan_common.c |   28 ++---------
 net/key/af_key.c              |   20 +------
 net/netrom/af_netrom.c        |   21 +-------
 net/netrom/nr_route.c         |   53 +++----------------
 net/packet/af_packet.c        |   20 +------
 net/rose/af_rose.c            |   22 +-------
 net/x25/x25_proc.c            |  114 ++++-------------------------------------
 16 files changed, 139 insertions(+), 408 deletions(-)
