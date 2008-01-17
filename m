Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYAQNWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYAQNWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYAQNWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:22:34 -0500
Received: from ag-out-0708.google.com ([72.14.246.251]:29780 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYAQNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:22:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lLIVDtuhG1NAjn7z9Sl2cOjhGrQiNfTe6dJ0owEriFR4jD4FBmMcuy0IlmJHSLv/eCzXz9qF2jwvUCzZxxYE/LmC+IgxQvOB2wtotRp3wHBdBGSYHyNp6ArUVJdwjFWFdRdcfRFDOV9mCIahCi1ZtRJqii3px2+McI7hcFB7ric=
Date: Thu, 17 Jan 2008 21:21:08 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [-mm Patch] UML: fix a building error
Message-ID: <20080117132108.GC2693@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 02:35:14AM -0800, Andrew Morton wrote:
>
>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
>

Hi, Andrew!

Building uml failed in current -mm tree. ;(

The below patch fixes this building error:
...
include/asm/arch/system.h:8:22: error: asm/nops.h: No such file or directory
...

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

Index: linux/include/asm-um/nops.h
===================================================================
--- /dev/null
+++ linux/include/asm-um/nops.h
@@ -0,0 +1,6 @@
+#ifndef __UM_NOPS_H
+#define __UM_NOPS_H
+
+#include "asm/arch/nops.h"
+
+#endif
