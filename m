Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbZIPVi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbZIPVi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZIPVi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:38:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:10750 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZIPVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=JpH5jgrnmhTMlI1Nx/A/ZhYM5gA1xfUDUax+OkkNUJt0HsgUVbS1Isg8o/r6CEMelV
         8QdqqscIh0vHc8Cw5T7Akq7NB/voXWVDcGskYgdG0cgGiwBc9LxdPQ0xMeeBoY1V9eiF
         4dUbFK9FdGetpHJJVinmNSubKVKwlVo6ZtM1w=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 0/6] Trivial warning cleanups
Date: Thu, 17 Sep 2009 00:38:37 +0300
Message-Id: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes all the warnings I get when building a kernel for my
laptop. Plus a few style issues cleanups.

v2: comments from Daniel Walker, and Mike Frysinger

Felipe Contreras (6):
  Trivial whitespace cleanups
  kbuild: fix warning when domainname is not available
  kbuild: mkcompile_h: trivial cleanups
  acpi: fix a bunch of style issues on 'actypes.h'
  acpi: fix trivial warning
  acpi: fix trivial warnings caused by previous commmit

 arch/x86/include/asm/string_32.h |    1 -
 arch/x86/kernel/tsc.c            |    2 +-
 drivers/acpi/acpica/exfldio.c    |    8 ++++----
 drivers/acpi/acpica/tbfadt.c     |    1 -
 include/acpi/actypes.h           |   36 ++++++++++++++++++------------------
 scripts/mkcompile_h              |   12 +++++++++---
 6 files changed, 32 insertions(+), 28 deletions(-)

