Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbYJPVwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbYJPVwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYJPVwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:52:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:30503 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbYJPVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HmObZKeXnab/rtiKwbEdEEIo3h3WY8179D4lmsVMsMM/H/aQmywzbsERMwxlRg+Snd
         kiv3c/xLtYcKcHKuglH5oxlZAY3pbTvSrItfWtgt1vYOrhKpVFPQi5FqhbQyuc1q5t6L
         KH2vYHti9XM8ngwjSjvRVpifp9g0AV5UEIadU=
Date: Fri, 17 Oct 2008 01:55:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, neilb@suse.de
Subject: [PATCH] md: msleep compile fix
Message-ID: <20081016215504.GA29044@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init/do_mounts_md.c:285: error: implicit declaration of function 'msleep'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 init/do_mounts_md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -1,4 +1,4 @@
-
+#include <linux/delay.h>
 #include <linux/raid/md.h>
 
 #include "do_mounts.h"
