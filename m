Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbXGTPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbXGTPA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbXGTPAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:00:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:56705 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760336AbXGTPAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=cFtH0Po5k1IUby7STX+WkDUIBlNd8eVeeNgQDbK0nw0bhCU535mCUb1Lkvn9pZX+VGqM3w9swZ0jP9KH4meHHreT5nH3/z7Fmh2Feqm4uhoJS5tgRwaLgIhebl2IY4/2sGNk+4dwSD8eExP3Mioj9mnepUEuu+OPsTRm+IjSg0g=
Message-ID: <46A0CD9C.2030503@googlemail.com>
Date: Fri, 20 Jul 2007 16:58:36 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Michael A. Halcrow" <mahalcro@us.ibm.com>
Subject: Re: [PATCH broken-out-2007-07-20-00-22] fs/ecryptfs/mmap.c remove
 unused label
References: <46A0CAE7.9000104@googlemail.com>
In-Reply-To: <46A0CAE7.9000104@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski pisze:
> Hi,
> 
> Mismerge fallout
> 
> fs/ecryptfs/mmap.c: In function 'ecryptfs_get_lower_page':
> fs/ecryptfs/mmap.c:585: warning: label 'retry' defined but not used
> 

Sorry, wrong patch format, no Signed-off-by

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work3-clean/fs/ecryptfs/mmap.c	2007-07-20 16:53:48.000000000 +0200
+++ linux-work3/fs/ecryptfs/mmap.c	2007-07-20 16:39:30.000000000 +0200
@@ -582,7 +582,6 @@ int ecryptfs_get_lower_page(struct page 
 {
 	int rc = 0;
 
-retry:
 	*lower_page = grab_cache_page(lower_inode->i_mapping, lower_page_index);
 	if (!(*lower_page)) {
 		rc = -EINVAL;
