Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYGQAs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYGQAs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYGQAsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:48:15 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:37632 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYGQAsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=BH7wSsQ7E3JZAEqaIBq1ockcm1arLkEK/MVI7i/wuHMdjwt7krsiD6fEMFbvZH/LWs
         7ETKvhS4KfUaSVy+9X6Zfv8NedR6pJzVwur2IrTXuRTZGe/mRb5LlFNG88LBNmYw0HUf
         jiD/F/M9qU+TGDsnluMg5SQrUBMXNm7iSAsRY=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] kmemtrace RFC (resubmit 1)
Date: Thu, 17 Jul 2008 03:46:44 +0300
Message-Id: <cover.1216255034.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I hopefully fixed previous complaints. Also wrote some documentation and
fixed some missing stuff in SLAB.

Please take a look and comment.

BTW, see Documentation/vm/kmemtrace.txt for details on how to use this and
for info on design details.


	Eduard

Eduard - Gabriel Munteanu (4):
  kmemtrace: Core implementation.
  kmemtrace: SLAB hooks.
  kmemtrace: SLUB hooks.
  kmemtrace: SLOB hooks.

 Documentation/kernel-parameters.txt |    6 +
 Documentation/vm/kmemtrace.txt      |   96 ++++++++++++++++
 MAINTAINERS                         |    6 +
 include/linux/kmemtrace.h           |  110 ++++++++++++++++++
 include/linux/slab_def.h            |   56 ++++++++-
 include/linux/slub_def.h            |    9 ++-
 init/main.c                         |    2 +
 lib/Kconfig.debug                   |    4 +
 mm/Makefile                         |    2 +-
 mm/kmemtrace.c                      |  208 +++++++++++++++++++++++++++++++++++
 mm/slab.c                           |   61 +++++++++-
 mm/slob.c                           |   37 +++++-
 mm/slub.c                           |   47 +++++++-
 13 files changed, 617 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/vm/kmemtrace.txt
 create mode 100644 include/linux/kmemtrace.h
 create mode 100644 mm/kmemtrace.c

