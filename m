Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbZKFWib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbZKFWib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbZKFWWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:48 -0500
Received: from kroah.org ([198.145.64.141]:56798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760158AbZKFWWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:42 2009
Message-Id: <20091106221542.845204599@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@linux.intel.com>
Subject: [32/99] dpt_i2o: Fix typo of EINVAL
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dpt_i2o-fix-typo-of-einval.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit aefba418bfecd1985a08f50a95bd854a119f0153 upstream.

Commit ef7562b7f28319e6dd1f85dc1af87df2a7a84832 ("dpt_i2o: Fix up
copy*user") had a silly typo: EINVAL should be -EINVAL.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/dpt_i2o.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1919,7 +1919,7 @@ static int adpt_i2o_passthru(adpt_hba* p
 		size = size>>16;
 		size *= 4;
 		if (size > MAX_MESSAGE_SIZE) {
-			rcode = EINVAL;
+			rcode = -EINVAL;
 			goto cleanup;
 		}
 		/* Copy in the user's I2O command */


