Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZKAKw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZKAKw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 05:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZKAKw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 05:52:59 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33891 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZKAKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 05:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HPGG0R7Juws58A/7t/6VA6sPsC9b3L7RTtm7V7plXK3008bgabOYrq+gI3XNAgZWEf
         hN5eGH6AKY7cJ6/rev9KOgRU6ROBejiVKUM2zdmGJs6ES4w1x94ZV4+SxA8XsKkNmlnP
         H48PTmYgFkeMvugljoPJjHpcYsRjNqK89V66A=
Date: Sun, 1 Nov 2009 13:52:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make DEBUG_BUGVERBOSE default to y
Message-ID: <20091101105258.GA2553@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's easy to lose useful DEBUG_BUGVERBOSE by switching EMBEDDED left and right.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -567,7 +567,7 @@ config DEBUG_BUGVERBOSE
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
-	default !EMBEDDED
+	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number
 	  of the BUG call as well as the EIP and oops trace.  This aids
