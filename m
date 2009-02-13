Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbZBMPHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbZBMPHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZBMPHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:07:07 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:1807 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZBMPHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:07:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hSWVpC93YmlPUmhqSs8PDjEGOZnRFf8q6vbhETJnjlXwNts4tYxu9WCWvrCfUDwAiN
         djnCxNStyo1WFjmRqodSTH1MRh7txSq733g7w+JyYv5vHwHw293ufT/q9wUqD6hKh0nt
         QuCt0P7hxZiJN/OsjDxn12vEGQ9yFjB5pEcRs=
Date: Fri, 13 Feb 2009 18:06:54 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: zbr@ioremap.net, gregkh@suse.de, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH next] Staging: pohmelfs should depend on CRYPTO
Message-ID: <20090213150654.GA7390@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/pohmelfs/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/pohmelfs/Kconfig b/drivers/staging/pohmelfs/Kconfig
index f150ecb..4c6276b 100644
--- a/drivers/staging/pohmelfs/Kconfig
+++ b/drivers/staging/pohmelfs/Kconfig
@@ -1,6 +1,7 @@
 config POHMELFS
 	tristate "POHMELFS filesystem support"
 	select CONNECTOR
+	select CRYPTO
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HMAC
 	help
