Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZFPCaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZFPCaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZFPCaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:30:00 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42572 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZFPC37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:29:59 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM-RFC PATCH 0/2] eventfd enhancements for irqfd/iosignalfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mst@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Date: Mon, 15 Jun 2009 22:29:51 -0400
Message-ID: <20090616022041.23890.90120.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:c27b64a0)

For more details, please read the patch headers.  This series adds
a new feature to eventfd (explicit notifications) which addresses
wqh based limitations, as well as provides fixes for several issues
in irqfd pointed out by Michael Tsirkin.  You can find reference to these
issues here:

http://lkml.org/lkml/2009/6/15/218
http://lkml.org/lkml/2009/6/11/249

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

---

Gregory Haskins (2):
      eventfd: add module reference counting support for registered notifiers
      eventfd: add an explicit srcu based notifier interface


 fs/eventfd.c            |  123 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/eventfd.h |   33 +++++++++++++
 virt/kvm/eventfd.c      |  114 ++++++++++++++++++++------------------------
 3 files changed, 199 insertions(+), 71 deletions(-)

-- 
Signature
