Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0BTVlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 16:41:23 -0500
Received: from ist.d-labs.de ([213.239.218.44]:55189 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078Ab0BTVlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 16:41:21 -0500
From: florian@mickler.org
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH 0/2] Document and enhance rfkill sysfs abi
Date: Sat, 20 Feb 2010 22:40:43 +0100
Message-Id: <1266702045-6062-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The first patch shuffles the sysfs-rfkill abi documentation into
Documentation/ABI. The second patch is more a "why not?" question in
patch-form. After stumbling over this arbitrary limitation of the rfkill*/state
in the Documentation.

Well.. why not?

Cheers,
Flo

Florian Mickler (2):
  Document the rfkill sysfs ABI
  enhance /sys/class/rfkill/<rfkill>/state interface

 Documentation/ABI/stable/sysfs-class-rfkill |   65 +++++++++++++++++++++++++++
 Documentation/rfkill.txt                    |   44 +++++-------------
 include/linux/rfkill.h                      |    3 +
 net/rfkill/core.c                           |    9 +++-
 4 files changed, 89 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-rfkill

