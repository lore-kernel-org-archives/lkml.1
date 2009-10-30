Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZJ3ICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZJ3ICe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZJ3ICd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:02:33 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:59687 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZJ3ICb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:02:31 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dpt_i2o: Fix typo of EINVAL
Date: Fri, 30 Oct 2009 17:02:31 +0900
Message-ID: <87y6mtmhrc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like ef7562b7f28319e6dd1f85dc1af87df2a7a84832 is including typo.
EINVAL should be -EINVAL?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: stable@kernel.org
Cc: Alan Cox <alan@linux.intel.com>
---

 drivers/scsi/dpt_i2o.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dpt_i2o.c~dpt_i2o-typo-fix drivers/scsi/dpt_i2o.c
--- linux-2.6/drivers/scsi/dpt_i2o.c~dpt_i2o-typo-fix	2009-10-30 16:48:56.000000000 +0900
+++ linux-2.6-hirofumi/drivers/scsi/dpt_i2o.c	2009-10-30 16:48:59.000000000 +0900
@@ -1919,7 +1919,7 @@ static int adpt_i2o_passthru(adpt_hba* p
 		size = size>>16;
 		size *= 4;
 		if (size > MAX_MESSAGE_SIZE) {
-			rcode = EINVAL;
+			rcode = -EINVAL;
 			goto cleanup;
 		}
 		/* Copy in the user's I2O command */
_
