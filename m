Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZLBVK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZLBVK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZLBVK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:10:26 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:51386 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZLBVKZ (ORCPT
	<rfc822;groupwise-PMullaney@novell.com:0:0>);
	Wed, 2 Dec 2009 16:10:25 -0500
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH 0/2] registration fixes for vbus venet macvlan driver
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 02 Dec 2009 16:10:19 -0500
Message-ID: <20091202204722.5116.33183.stgit@mimic.site>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to alacrityvm.git/master:4ac12ced9)

These patches fix some netdev registration problems discovered with
the venet macvlan driver. The newline patch is trivial. The other
patch addresses several problems with registration. Worth noting
are the problems registering a netdevice that has previously been
unregistered. This doesn't seem work and I was wondering if this
is expected behavior in net/core(see patch 2/2 for a description).

---

Patrick Mullaney (2):
      venet: Fixes for shutdown and re-registration of venet devices.
      venet-macvlan: correctly remove newline from lower device name


 kernel/vbus/devices/venet/device.c      |   11 ++++--
 kernel/vbus/devices/venet/macvlan.c     |   61 +++++++++++++++++++++++++------
 kernel/vbus/devices/venet/venetdevice.h |    7 +++-
 3 files changed, 63 insertions(+), 16 deletions(-)

-- 
