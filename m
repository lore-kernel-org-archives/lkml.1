Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXCMTQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXCMTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbXCMTQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:16:27 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:37828 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051AbXCMTQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:16:26 -0400
Message-ID: <45F6F84D.20302@free.fr>
Date: Tue, 13 Mar 2007 20:15:25 +0100
From: Zoltan Menyhart <Zoltan.Menyhart@free.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.13) Gecko/20060414
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
CC: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Subject: copy_one_pte()
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had a look at copy_one_pte().
I cannot see any ioproc_update_page() call, not even for the COW pages.
Is it intentional?

We can live with a COW page for a considerably long time.
How could the IO-PROC. know that a process-ID / user virt. addr. pair
refers to the same page?

The comment above ioproc_update_page() says that every time when a PTE
is created / modified...

Thanks,

Zoltan Menyhart

