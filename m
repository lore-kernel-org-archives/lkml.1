Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZC2VWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZC2VWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZC2VVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:21:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:62907 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZC2VVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pmg17TO2FRscXtGbEAACPY/QfGDIYz+e/30TK8z614nJGUEBm5+2s/vu428RFx3foT
         3Iq/6C6sTVbWQrDkQFaKLDJJsTZAxQmdWe/bQ5/wQNmDbfhkv/GLAZg+amSgrfqmmk0g
         ouT06xRMgZs0KaWSJuEwns196uKCUoeEnt6IU=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, w@1wt.eu, mingo@elte.hu, hpa@zytor.com,
       jeremy@goop.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 0/2] x86: Remove direct access to internal x86 descriptor fields
Date: Sun, 29 Mar 2009 14:21:40 -0700
Message-Id: <cover.1238361501.git.ice799@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

This patch set aims to remove the direct access to the 'a' and 'b' fields of 32-bit x86 descriptors. Static inline getters/setters are provided.

This is a resumbmit of a patch set I submitted several months ago[1]. My last patch set was a bit large, so I've tried to take a smaller bite this time and slowly build the cleanup effort over a series of patch sets.

Any and all comments, suggestions, and questions are welcome.

Thanks,
Joe Damato

[1] http://lkml.org/lkml/2008/10/24/459

---

Joe Damato (2):
  x86: Add getter/setter static inlines for x86 descriptors
  x86: Replace direct access to descriptor fields with getter/setters

 arch/x86/include/asm/desc.h           |   32 ++++++++++++++++++++++++++------
 arch/x86/include/asm/xen/hypercall.h  |    5 +++--
 arch/x86/kernel/tls.c                 |    6 ++++--
 arch/x86/kernel/vmi_32.c              |    3 ++-
 arch/x86/lguest/boot.c                |    2 +-
 arch/x86/math-emu/fpu_system.h        |   20 ++++++++++----------
 drivers/lguest/interrupts_and_traps.c |   25 +++++++++++++------------
 drivers/lguest/segments.c             |   20 ++++++++++++--------
 drivers/pnp/pnpbios/bioscalls.c       |    4 ++--
 9 files changed, 73 insertions(+), 44 deletions(-)

