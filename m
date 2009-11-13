Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbZKMTzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbZKMTzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZKMTzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:55:17 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:45405 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbZKMTzM (ORCPT
	<rfc822;groupwise-PMullaney@novell.com;0:0>);
	Fri, 13 Nov 2009 14:55:12 -0500
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH 0/3] macvlan: support for guest vm direct rx/tx
To: kaber@trash.net, netdev@vger.kernel.org
Cc: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       arnd@arndb.de, bridge@lists.linux-foundation.org
Date: Fri, 13 Nov 2009 14:55:06 -0500
Message-ID: <20091113195201.11184.25766.stgit@mimic.site>
In-Reply-To: <4AFAD86A.9070506@trash.net>
References: <4AFAD86A.9070506@trash.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to net-2.6.git/master:1dfc5827)

These patches allow other modules to override the receive
path of a macvlan. This is being done to support guest
VMs operating directly over a macvlan. Routines to allow
creation and deletion of macvlans from in-kernel modules
were also exposed/added.

---

Patrick Mullaney (3):
      macvlan: allow in-kernel modules to create and manage macvlan devices
      macvlan:  derived from Arnd Bergmann's patch for macvtap
      netdevice: provide common routine for macvlan and vlan operstate management


 drivers/net/macvlan.c     |  135 ++++++++++++++++++++++-----------------------
 include/linux/macvlan.h   |   41 ++++++++++++++
 include/linux/netdevice.h |    3 +
 net/8021q/vlan.c          |   29 +---------
 net/core/dev.c            |   27 +++++++++
 5 files changed, 142 insertions(+), 93 deletions(-)
 create mode 100644 include/linux/macvlan.h

