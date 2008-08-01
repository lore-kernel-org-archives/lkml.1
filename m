Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYHAAEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYHAAEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 20:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYHAAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 20:04:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:29177 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbYHAAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 20:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UqvXCj26gWcjaPT47hXXvxIAuD0RaNmriD+H5w5cwOlEF5IAdZFg/T2DxUrhCkmkJI
         mAjlV5gOuGyyB5wzTP8eKfha9nQ+2+hsTdQcAlFUmiul9DBS3UwDVdAyrF/mcHsb3+E0
         ufCUqSKN3A4dhk9rptladoHOkGrrrAtY6THQg=
Date: Fri, 1 Aug 2008 04:04:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: penberg@cs.helsinki.fi, cl@linux-foundation.org
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
Message-ID: <20080801000405.GA7072@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
to hell with tunables.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -736,7 +736,7 @@ config VM_EVENT_COUNTERS
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EMBEDDED
-	depends on SLUB && SYSFS
+	depends on SLUB
 	help
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables

