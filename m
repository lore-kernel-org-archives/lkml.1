Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZIMTii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZIMTii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZIMTih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:38:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:1354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbZIMTig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=YL16bdhOAFckFTzuFy8iMXJzINze8OTO+SETSmuYVqlk2CrEW6K0Sli3GKEI5Lc7Sl
         cFllC/WxcBHWSCakbmYQUTeevg9PbQ2GRhW7Hqra0HIvnUMa5Jf9c//PR/3PZjIh14fC
         6DRMJXBeKj6ZWl3gaCID/fLo4StC9Tj5B/vro=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/5] Trivial warning cleanups
Date: Sun, 13 Sep 2009 22:38:22 +0300
Message-Id: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes all the warnings I get when building a kernel for my
laptop. Plus a few whitespace cleanups I found along the way.

Felipe Contreras (5):
  Trivial whitespace cleanups
  kbuild: fix warning when domainname is not available
  kbuild: mkcompile_h: trivial cleanups
  acpi: fix trivial warning
  acpi: fix trivial warnings caused by previous commmit

 arch/x86/include/asm/string_32.h |    1 -
 arch/x86/kernel/tsc.c            |    2 +-
 drivers/acpi/acpica/exfldio.c    |    8 ++++----
 drivers/acpi/acpica/tbfadt.c     |    1 -
 include/acpi/actypes.h           |    4 ++--
 scripts/mkcompile_h              |   12 +++++++++---
 6 files changed, 16 insertions(+), 12 deletions(-)

