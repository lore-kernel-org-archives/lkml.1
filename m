Return-Path: <linux-kernel-owner+w=401wt.eu-S934309AbXGLAzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309AbXGLAzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936214AbXGLAzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:55:11 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:24655 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935674AbXGLAzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:55:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=o7U/SSZFx5sWts01AOqrwubC+pttnPE0OJ8uXGoJALotRT1BeBY8BkCdwe764cG5/Y5AoFhNB1dtI2J2B3dL7wwZ30KZj0Lu2g2GB+XrclG/qZ4xldgBmp0aMPIDDFRggq3vOJJ/5PQXuw+Q4G6NfrpgT+5V1Zb9Z5Qc8FwvCWE=  ;
X-YMail-OSG: 1YySoaYVM1lzYDiSaRTyEdjdvfGPVb0Amm5XHhQY8rP1ct67BGZZd7TjUGg_ttQrBiSTWZcLkg--
Message-ID: <46957BE1.1010104@yahoo.com.au>
Date: Thu, 12 Jul 2007 10:54:57 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Linux Memory Management <linux-mm@kvack.org>
Subject: fault vs invalidate race (Re: -mm merge plans for 2.6.23)
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
> mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
> mm-merge-nopfn-into-fault.patch
> convert-hugetlbfs-to-use-vm_ops-fault.patch
> mm-remove-legacy-cruft.patch
> mm-debug-check-for-the-fault-vs-invalidate-race.patch
> mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
> invalidate_mapping_pages-add-cond_resched.patch
> ocfs2-release-page-lock-before-calling-page_mkwrite.patch
> document-page_mkwrite-locking.patch
> 
>  The fault-vs-invalidate race fix.  I have belatedly learned that these need
>  more work, so their state is uncertain.

The more work may turn out being too much for you (although it is nothing
exactly tricky that would introduce subtle bugs, it is a fair amont of churn).

However, in that case we can still merge these two:

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch

Which fix real bugs that need fixing (and will at least help to get some of
my patches off your hands).

-- 
SUSE Labs, Novell Inc.
