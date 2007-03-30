Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbXC3Nzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbXC3Nzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXC3Nzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:55:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:32645 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXC3Nzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=LTMFrzLD5Q5yECQSoiPe8wOF8ElXEWVogxgNi9cdClKgv5Zo1vOtNK9QpX8fNJBiG6WlyMsle6grB1Lhgip/ZOZ62osa276LI9pdbqDxJS5nJfchIoU+eo4pLRW11m2sl/ztiK/m4UgmytGKHJgRqc+XIyU081vDYi8UiV7Y2NQ=
Message-ID: <460D16CC.2070708@gmail.com>
Date: Fri, 30 Mar 2007 21:55:24 +0800
From: Bin Chen <binary.chen@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: What is the active page in Linux kernel, so inactive?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am quite confusing about the concept that Linux usage of the term
active and inactive pages. Some book tells me active pages is the
'working set' in system, but what is the 'working set'? There is a
page cache system in the system, and when a page is freed when not
needed by some way, the page will first considered be added to the
page cache. Once some stuff need more pages, it also get it from page
cache.

So it is easy to understand that there is two list in the page cache,
one for 'used' pages, that is, the page actually used by some one. And
the other one is 'unused', that is, unused by any one but is still
cached.

But I doubt whether the 'used' and 'unused' correspond to active and
inactive correctly? If I am right, when the system memory is tight,
the pages in the active list will be swapped out and the pages will be
added to the inactive list? Or the pages that has swapped out go
directly to the buddy allocator?

Thanks in advance.

abai
