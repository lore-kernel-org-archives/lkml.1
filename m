Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZLBIla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZLBIla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZLBIl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:41:29 -0500
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:34653 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZLBIl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:41:29 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: penberg@cs.helsinki.fi, catalin.marinas@arm.com,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [PATCH 0/2] fix for kmemleak_erase() (Re: Q, slab, kmemleak_erase() and redzone?)
Date: Wed,  2 Dec 2009 16:55:48 +0900
Message-Id: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg:
> No, you are absolutely correct. Can you please send an updated patch to 
> Catalin that adds a comment on top of the cpu_cache_get() call that 
> explains why we need it there?

J. R. Okajima (2):
  slab, kmemleak, minor, stop calling kmemleak_erase() unconditionally
  slab, kmemleak, bugfix, pass the correct pointer to kmemleak_erase()

 mm/slab.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

