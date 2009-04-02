Return-Path: <linux-kernel-owner+w=401wt.eu-S935964AbZDBLVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935964AbZDBLVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935927AbZDBLVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:21:32 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:35507 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935984AbZDBLV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=PBWXVorPvjIfCJNhAeqM6xpNnpKBXnhxVKXIUy1UGLkBFj5IqtNv/JkBCk5/iuMXd/
         TqGNbvBTunHsb7pXqC0Q8J0Uw0WvGzS+UBlinpPpjdXojS9WJui0J4DfDYeThFFJghMR
         W6VMwzuKZEjtQKLqxC7nmGnjazA2he6pf/8jE=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 15:21:25 +0400
Message-ID: <a4423d670904020421k7395e11dwe70d4223cb817e0a@mail.gmail.com>
Subject: next-0402: build fails at mm/debug-pagealloc.c
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/debug-pagealloc.c: In function 'set_page_poison':
mm/debug-pagealloc.c:8: error: 'struct page' has no member named 'debug_flags'
mm/debug-pagealloc.c: In function 'clear_page_poison':
mm/debug-pagealloc.c:13: error: 'struct page' has no member named 'debug_flags'
mm/debug-pagealloc.c: In function 'page_poison':
mm/debug-pagealloc.c:18: error: 'struct page' has no member named 'debug_flags'
mm/debug-pagealloc.c: At top level:
mm/debug-pagealloc.c:120: error: redefinition of 'kernel_map_pages'
include/linux/mm.h:1278: error: previous definition of
'kernel_map_pages' was here
mm/debug-pagealloc.c: In function 'kernel_map_pages':
mm/debug-pagealloc.c:122: error: 'debug_pagealloc_enabled' undeclared
(first use in this function)

Should debug_flags really be in vm_area_struct instead of `struct page` ?
