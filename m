Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYAAHd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYAAHd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYAAHdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:33:21 -0500
Received: from po-out-1718.google.com ([72.14.252.158]:56268 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYAAHdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:33:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=wiHPH5RbO9twwyb7Z4vWitfgsq8iSkEUpNAPNZCU7pLKFcoCy2l1PlM/dcQW2vCsuJ87guATBjMt157H8q60ZQKZji+7tMY/shWELy3sI+qdMp4oqlHYwJqykU3FlZLh5IOvB/NaFqPEmxmR3m0a0bm8KJpg1ZYuLPjhoGPJ76c=
Date: Tue, 1 Jan 2008 15:33:31 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Roland Dreier <rolandd@cisco.com>, mshefty@ichips.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       hal.rosenstock@gmail.com
Subject: [Patch 5/8] INFINIBAND: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101073331.GF2496@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, use objtree instead.
This patch removes TOPDIR from all infiniband Makefiles.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <mshefty@ichips.intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/drivers/infiniband/hw/cxgb3/Makefile b/drivers/infiniband/hw/cxgb3/Makefile
index 36b9898..b82286a 100644
--- a/drivers/infiniband/hw/cxgb3/Makefile
+++ b/drivers/infiniband/hw/cxgb3/Makefile
@@ -1,5 +1,5 @@
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3 \
-		-I$(TOPDIR)/drivers/infiniband/hw/cxgb3/core
+EXTRA_CFLAGS += -I$(objtree)/drivers/net/cxgb3 \
+		-I$(objtree)/drivers/infiniband/hw/cxgb3/core
 
 obj-$(CONFIG_INFINIBAND_CXGB3) += iw_cxgb3.o
 
