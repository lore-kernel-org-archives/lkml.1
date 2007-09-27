Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbXI0PQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbXI0PQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbXI0PQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:16:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbXI0PQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:16:44 -0400
Date: Thu, 27 Sep 2007 11:16:10 -0400
From: Rik van Riel <riel@redhat.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kumar Gala <galak@kernel.crashing.org>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: remove unnecessary wait in
 throttle_vm_writeout()
Message-ID: <20070927111610.68584fdd@bree.surriel.com>
In-Reply-To: <390857819.00313@ustc.edu.cn>
References: <390857819.00313@ustc.edu.cn>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 09:50:16 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> We don't want to introduce pointless delays in throttle_vm_writeout()
> when the writeback limits are not yet exceeded, do we?

Good catch.

> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
