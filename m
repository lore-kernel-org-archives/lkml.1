Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXE2Vfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXE2Vfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbXE2VfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:35:23 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:37158 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbXE2VfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:35:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=ohkaWXDZ4t/IMFN4H60JqxT/YZvsvGLWYxMyK4r/IIFMRijZMT1w8lFL/0DLrfjOXz6UJ9aTBKJ6W7HI86DTcYFmrU8QmWXbVJL5XRaerHGwoQz92WGmG3nYKjNhI7n9adNttL35/e2YrSn2eDHJSlh6QwZ9KvFTJdayBSJ76Qc=
Message-ID: <e55525570705291435i9c50addsc37c166cd469f169@mail.gmail.com>
Date: Tue, 29 May 2007 17:35:15 -0400
From: "Anderson Briglia" <briglia.anderson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Trivial fixes on comments related old shrink_list reference
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_33598_6862323.1180474515392"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_33598_6862323.1180474515392
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

This is just a trivial patch to fix the shrink_list name on some files
under mm/ directory.

Signed-off-by: Anderson Briglia <anderson.briglia@indt.org.br>
---
Index: linux-linus-2.6.git/mm/swap_state.c
===================================================================
--- linux-linus-2.6.git.orig/mm/swap_state.c	2007-05-29 17:12:56.000000000 -0400
+++ linux-linus-2.6.git/mm/swap_state.c	2007-05-29 17:13:59.000000000 -0400
@@ -21,7 +21,7 @@

 /*
  * swapper_space is a fiction, retained to simplify the path through
- * vmscan's shrink_list, to make sync_page look nicer, and to allow
+ * vmscan's shrink_page_list, to make sync_page look nicer, and to allow
  * future use of radix_tree tags in the swap cache.
  */
 static const struct address_space_operations swap_aops = {
Index: linux-linus-2.6.git/mm/swapfile.c
===================================================================
--- linux-linus-2.6.git.orig/mm/swapfile.c	2007-05-29 17:12:49.000000000 -0400
+++ linux-linus-2.6.git/mm/swapfile.c	2007-05-29 17:13:39.000000000 -0400
@@ -885,7 +885,7 @@ static int try_to_unuse(unsigned int typ
 		/*
 		 * So we could skip searching mms once swap count went
 		 * to 1, we did not mark any present ptes as dirty: must
-		 * mark page dirty so shrink_list will preserve it.
+		 * mark page dirty so shrink_page_list will preserve it.
 		 */
 		SetPageDirty(page);
 		unlock_page(page);
Index: linux-linus-2.6.git/mm/truncate.c
===================================================================
--- linux-linus-2.6.git.orig/mm/truncate.c	2007-05-29 17:13:08.000000000 -0400
+++ linux-linus-2.6.git/mm/truncate.c	2007-05-29 17:15:03.000000000 -0400
@@ -317,8 +317,8 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * This is like invalidate_complete_page(), except it ignores the page's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
  * invalidation guarantees, and cannot afford to leave pages behind because
- * shrink_list() has a temp ref on them, or because they're transiently sitting
- * in the lru_cache_add() pagevecs.
+ * shrink_page_list() has a temp ref on them, or because they're transiently
+ * sitting in the lru_cache_add() pagevecs.
  */
 static int
 invalidate_complete_page2(struct address_space *mapping, struct page *page)

------=_Part_33598_6862323.1180474515392
Content-Type: application/x-bzip2; name=trivial_shrink_list_comment.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2aw0kca
Content-Disposition: attachment; filename="trivial_shrink_list_comment.tar.bz2"

QlpoOTFBWSZTWamQIVsAA9J/xMowAgBA/////ibc4P/v3+gAAgAEAAhQBB6urY1mylJVIMUqflGK
ZNonpH6p6NQ9IAA0GhpoaNP0po9QOaZGQyYIaMJgjTRoxA0yZGAAIMQRE8qYJtEmmjQaABoAGgBo
NA5pkZDJghowmCNNGjEDTJkYAAgkhTRoaENNGginkT1D1PU0NANA0AaaNPp+/d7oYEpyQgOehrq0
5GLJJOk+m90ZC+0TE1+D9E9PCtMKo4hbkjGoPyK6Xe+fDzc5mNk7Fd58tBMyJuvqJs4z8h4iHgyO
zxbzC5q6ns8hefsna3yey73jGxdVed888fdbguy/Fk6MKuq+fkG914wzC2bapU1YaH4Tw7EkpBIr
sL5U3FJ/yU2l1ZIsG9/+yU95ha+MXu7vOKOahupmxuHwY5DIRixgW5K3OIUjMFApMHz4imIgcsYb
lsMahjBVtcooAIvATgosLqA/SLmGUdI7UqRq9zJkmCgoFRA8hMdkz/UHB91js31+Hg3pbVBt3WoL
EEwv7V45TkMwzGiCPQJHpEwHq8vQJiDITuS8uYLpUKORdMnzkiLHs4DFgtdL0G4TdXPXbANheHpe
TVSCvRgJ4RIOgPVV1ayBTXEdoBioWLgQRcY41ivnn5+aaIyE1Y3cuB3LwQeZl4ha0oci9FfwMcfW
GbPDfdVi/pPlDRCq4MlYYB5JJBDKExI9TOjArJpxeM9ZlKsG0Zg0SJoBegBsjGP0hwiCPO2BfH7A
iow2a3PwFb0zJJe0B3LWgDChHm1fhvIyDNeor2mo8K0PhHbWwyhY60vLl+F5orqEP64LqsxpIoFK
0XBDVldWWfXUY9vbKXUkcypoYqkWyGg1LI005BIpOHDFisEN6lP6BYZzazYMZsHGNvXMwxY6mRWT
le2DOjvbYQWLPEsNOLvwlguVcbN4YOnsAGZGvRBUlFeeW6BkQmDF3796T5gxuM+/BEhaCW2Wih2i
YOXh03D5CxPFU2BAR+aqeuR7WquGsSZaIMTZXTmMZhoy47id5yqVMzALEPHNAyDelWSLqi0YzOR0
QQeu11H6oN0Vjlp4xMCChcIdsai0Qf4ugvvpYMRRgxNaNOqaSKNeqQdlDByA6BL6QdgW7jbZa2Vx
uONpCZuB4mcMKzlf3gxbNTNJnEvcKK9UGY5do4Qwxg3TTgWGYsYMbWTuGHYUbBLqegcE0MYngDuB
iOVcZVym95uDeVCgbCkrCTs/SDKsx1sWxBxH4FhUHXBR/yNSgekNpkUm5LQaAbkR1gUaC1xux1s8
yiiVIWhiBfBSTrJDCkDGGJCO+FipEE7zDTCii4xyCGM2WQy+bbBdjRBgWsPn7uyBK8lmWFxtEOjJ
Bskmbja2BfUPyalw93kkl/4u5IpwoSFTIEK2
------=_Part_33598_6862323.1180474515392--
