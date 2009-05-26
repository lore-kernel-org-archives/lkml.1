Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZEZOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZEZOnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZEZOnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:43:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZEZOnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:43:14 -0400
Date: Tue, 26 May 2009 09:48:19 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 17/38] groups: move code to kernel/groups.c
Message-ID: <20090526144819.GA21502@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-17-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-17-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> Move supplementary groups implementation to kernel/groups.c .
> kernel/sys.c already accumulated quite a few random stuff.
> 
> Do strictly copy/paste + add required headers to compile.
> Compile-tested on many configs and archs.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Actually I needed the following change:

>From 81e683ae07cfe24d98d6df384bbd37f1f7f80c38 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Tue, 26 May 2009 10:39:47 -0400
Subject: [PATCH 1/1] groups: allow compilation on s390x

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/groups.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/groups.c b/kernel/groups.c
index 1b95b2f..14ebc6a 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -1,6 +1,7 @@
 /*
  * Supplementary group IDs
  */
+#include <linux/init.h>
 #include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-- 
1.6.1

