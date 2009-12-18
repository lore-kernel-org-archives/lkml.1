Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbZLREFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbZLREFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 23:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZLREFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 23:05:17 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:42450 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZLREFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 23:05:16 -0500
Message-ID: <4B2AFF4C.5010100@ct.jp.nec.com>
Date: Fri, 18 Dec 2009 13:04:28 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: revert "config FS_JOURNAL_INFO"
References: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>
In-Reply-To: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Can we please revert commit e4c570c4cb7a95dbfafa3d016d2739bf3fdfe319
> "task_struct: make journal_info conditional"

I'm fine to revert it, because it seems merged accidentally.

> 
> I think I gave a good enough arguments to not merge it.
> To iterate:
> * patch makes impossible to start using ext3 on EXT3_FS=n kernels
> without reboot.
> * this is done only for one pointer on task_struct

I don't think it's only one pointer.
There might be a lot of "only one pointer".

> 
> None of config options which define task_struct are tristate directly
> or effectively.

So we never allow to make memory usage small with providing an option
to remove unused area, right? Of cause, that option should be handled
carefully. If I want to reduce memory usage by this way, should I keep
this kind of patches out of tree?

thanks,
Hiroshi

