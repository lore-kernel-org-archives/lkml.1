Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXJ2NqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXJ2NqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbXJ2Npr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:45:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:38191 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbXJ2Npq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:x-url:organization:user-agent:sender;
        b=B1dA7TNnaHtdevOSAOslCkcRMzPjZGZvrTUToo5XfQq4bSlXCmsEJb2kDhlDN1L0k0lHpJJZvAEiF8FWuTNieoFtB8GLxqMZXdw4n5BhPbwR44m/8pTEdjXnJH2pwKYmP9ZmsTcJLA55u6j709UczOx/WC9q7QnOp8+RLHCoYLg=
Date: Mon, 29 Oct 2007 11:45:39 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]: linux/interrupt.h doesn't need sched.h
Message-ID: <20071029134539.GB7810@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2306920..5a0fc81 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -9,7 +9,6 @@
 #include <linux/cpumask.h>
 #include <linux/irqreturn.h>
 #include <linux/hardirq.h>
-#include <linux/sched.h>
 #include <linux/irqflags.h>
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
