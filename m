Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXGTOsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXGTOsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbXGTOsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:48:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42613 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbXGTOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ZVRih25wqsOFt9sMBFUs0AvsGOV/aMKJ7UqESA1sYKg31yZxXT5/tW2RVdftNldAcIIhlkkSUdVRrlUkLI1IlUrbkffywB0vdAaNzvlsM2JC6f7jFJbtaFGZ5rZwCQJDEVoqE3nPXTCum/7NnCjnCWrtKHmYe1mKCTpmXRWwKHE=
Message-ID: <46A0CAE7.9000104@googlemail.com>
Date: Fri, 20 Jul 2007 16:47:03 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Michael A. Halcrow" <mahalcro@us.ibm.com>
Subject: [PATCH broken-out-2007-07-20-00-22] fs/ecryptfs/mmap.c remove unused
 label
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mismerge fallout

fs/ecryptfs/mmap.c: In function 'ecryptfs_get_lower_page':
fs/ecryptfs/mmap.c:585: warning: label 'retry' defined but not used

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

--- fs/ecryptfs/mmap.c2	2007-07-20 16:39:13.000000000 +0200
+++ fs/ecryptfs/mmap.c	2007-07-20 16:39:30.000000000 +0200
@@ -582,7 +582,6 @@ int ecryptfs_get_lower_page(struct page 
 {
 	int rc = 0;
 
-retry:
 	*lower_page = grab_cache_page(lower_inode->i_mapping, lower_page_index);
 	if (!(*lower_page)) {
 		rc = -EINVAL;
