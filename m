Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZHZVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZHZVWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZHZVWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:22:24 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:61016 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZHZVWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BfRNM0aeFqNPYPcfrSJwln9G86sn1UdakBgDzll3uJvWhaBJex1660lBYxqgIQw/ZE
         WEf1cIe9nI44PQTm6DWHs91hkN2EGnzTfciekditlASNlvXFi3QpYkWO0oSSZTcpTogi
         W8MpyyswU8PKXBPXJguGfPaRIJwtRLXzkehIA=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 14:22:24 -0700
Message-ID: <689eb3470908261422u50e59d9ex1a3c43fdc2f3d4e8@mail.gmail.com>
Subject: Differentiating clean and dirty buffer cache pages
From: Anupama Chandwani <anupama.chandwani@gmail.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Krishna Raj Raja <krraja@vmware.com>, vrajesh@vmware.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to get stats about what pages in the buffer cache are clean versus dirty.
I traverse the page_tree pointer of the radix tree of each open file
to get all buffer cache pages.

To identify dirty pages, I think of doing the following:
Level 1. Do a gang lookup in radix tree for PAGECACHE_TAG_DIRTY tag,
Level 2. Check the PTE of buffer cache pages for bit 6(D)

I want to know if checking these two data structures will give me a
complete list of all the dirty pages in the buffer cache?


-- 
Cheers,
Anupama Chandwani
