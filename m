Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbZIPQmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbZIPQmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759868AbZIPQmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:42:04 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39410 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759854AbZIPQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:41:59 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 0/2] Linker script cleanup patches for frv
Date: Wed, 16 Sep 2009 12:41:27 -0400
Message-Id: <1253119289-19261-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent in late July
cleaning up the frv architecture's linker scripts.  The only change is
that it is rebased on top of Linus's current master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Nelson Elhage (2):
  frv: remove unused .altinstructions code
  frv: clean up linker script using new linker script macros.

 arch/frv/kernel/vmlinux.lds.S |   66 ++++------------------------------------
 1 files changed, 7 insertions(+), 59 deletions(-)

