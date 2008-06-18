Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYFRVPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYFRVPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYFRVPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:15:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:24861 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYFRVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=AgKWFmk9NpSHqrBbaU8iBmdu8iBmnR1eiLzi/ozJRU9bmuJlAhHauY7XBiUGJ+G8ch
         LmBKcN5FUTLJpKUeYekSWPfndkn3se6OWrc6Or4s+NA+fYNeWZi3wiH+/+A3clq9iEJR
         0nHuojuJK0xw3Qg7Z4mhVm2VdivFNxVBsFlAg=
Message-ID: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
Date: Wed, 18 Jun 2008 17:15:08 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] Lockless patches cause hardlock under heavy IO
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I applied the following patches from 2.6-26-rc5-mm3 to 2.6.26-rc6 and
they caused a hardlock under heavy IO:

x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
#
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
#mm-speculative-page-references.patch: clameter saw bustage
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-hugh-fix3.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch

I am on an x86_64. I dont know what other info you need...

-Ryan
