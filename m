Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYDVHGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYDVHGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbYDVHGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:06:25 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52011 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755108AbYDVHGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:06:24 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com,
       yamahata@valinux.co.jp
Subject: [PATCH 0/3] xen: more portability patches
Date: Tue, 22 Apr 2008 16:00:03 +0900
Message-Id: <12088476062604-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy.
Here are the 3 patches for ia64/xen support.
The first one is just to move manage.c under drivers/xen.
This is trivial.

The second and third ones are for compilation fix on ia64.
You may want to postpone those 2 patches to make your merge task
easy as you said before.

thanks,

Diffstat
 arch/x86/xen/Makefile              |    2 +-
 drivers/xen/Makefile               |    2 +-
 drivers/xen/balloon.c              |    8 ++++----
 {arch/x86 => drivers}/xen/manage.c |    0 
 include/xen/interface/memory.h     |   12 ++++++++----
 5 files changed, 14 insertions(+), 10 deletions(-)
 rename {arch/x86 => drivers}/xen/manage.c (100%)
