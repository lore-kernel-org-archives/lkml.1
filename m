Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab0BEBoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:44:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49731 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab0BEBoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:44:16 -0500
Message-ID: <4B6B77FE.5000104@cn.fujitsu.com>
Date: Fri, 05 Feb 2010 09:44:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 00/13] net: simplify seq_file code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces seq_hlist_foo() helpers, and convert
net/* to seq_hlist_foo() and seq_list_foo().

---
 fs/seq_file.c                 |   37 ++++++++++++-
 include/linux/seq_file.h      |   11 ++++
 include/net/sock.h            |    5 ++
 net/appletalk/atalk_proc.c    |   30 +----------
 net/atm/proc.c                |    2 +-
 net/atm/resources.c           |   28 +++--------
 net/ax25/af_ax25.c            |   18 +-----
 net/ax25/ax25_uid.c           |   25 ++--------
 net/ipx/ipx_proc.c            |   89 ++++---------------------------
 net/irda/irlan/irlan_common.c |   26 ++--------
 net/key/af_key.c              |   20 +------
 net/netrom/af_netrom.c        |   21 +-------
 net/netrom/nr_route.c         |   53 +++----------------
 net/packet/af_packet.c        |   20 +------
 net/rose/af_rose.c            |   22 +-------
 net/x25/x25_proc.c            |  114 ++++-------------------------------------
 16 files changed, 116 insertions(+), 405 deletions(-)

