Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZHFAvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZHFAvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZHFAvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:51:13 -0400
Received: from mail.atheros.com ([12.36.123.2]:29952 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZHFAvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:51:13 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>,
       <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] checkincludes.pl: add removal option
Date: Wed, 5 Aug 2009 17:51:09 -0700
Message-ID: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets you remove duplicate includes headers in place with
checkincludes.pl, that is, the same file is overwritten with -r.
This actually makes this useful for me for porting crap drivers
where I have to do this a lot.

I don't know who these go through so sending to a few of you.

Luis R. Rodriguez (3):
  checkincludes.pl: close file as soon as we're done with it
  checkincludes.pl: provide usage helper
  checkincludes.pl: add option to remove duplicates in place

 scripts/checkincludes.pl |   62 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 58 insertions(+), 4 deletions(-)

