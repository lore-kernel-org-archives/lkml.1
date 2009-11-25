Return-Path: <linux-kernel-owner+w=401wt.eu-S934577AbZKYIR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577AbZKYIR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbZKYIR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:17:56 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56547 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZKYIRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:17:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=YdJXWc3d4id27xET6L9YW3wIBX2QTK09PYnnkNZmzv7QCaUXfsrD8nLUZ/rNZre19I
         azIE0pTvAt/BZ8HPERZAdZNVGMeZ2Lf9opcAMOTlHW9ZRx/sqTKpeo3/00dfVqDOhrGg
         HUBQOsVESbh2fIZYfHgrK/ek8szYG9GyUJOmE=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-sh@vger.kernel.org, johnstul@us.ibm.com,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       tglx@linutronix.de
Date: Wed, 25 Nov 2009 17:12:35 +0900
Message-Id: <20091125081235.25416.32481.sendpatchset@rxone.opensource.se>
Subject: [PATCH 00/02] clocksource: SuperH CMT driver resume changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource: SuperH CMT driver resume changes

[PATCH 01/02] clocksource: Add argument to resume callback
[PATCH 02/02] clocksource: Start CMT at clocksource resume

These patches modify the clocksource code so the CMT
driver can be resumed properly. Trivial stuff, but may
cause slight breakage if I managed to miss any clocksource
drivers that use the resume callback.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/ia64/kernel/time.c      |    4 ++--
 arch/x86/kernel/hpet.c       |    4 ++--
 arch/x86/kernel/tsc.c        |    4 ++--
 drivers/clocksource/sh_cmt.c |   16 ++++++++++++++++
 include/linux/clocksource.h  |    4 ++--
 kernel/time/clocksource.c    |    4 ++--
 6 files changed, 26 insertions(+), 10 deletions(-)
