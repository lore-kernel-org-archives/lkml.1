Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZEDWoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZEDWoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZEDWn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:43:59 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:41399 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751765AbZEDWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:43:58 -0400
Date: Tue, 05 May 2009 07:43:58 +0900 (JST)
Message-Id: <20090505.074358.226774631.ryov@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 4/7] blkio-cgroup: The body of blkio-cgroup
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090504120544.GA3986@linux>
References: <20090428.214535.71090234.ryov@valinux.co.jp>
	<20090428.214604.104034341.ryov@valinux.co.jp>
	<20090504120544.GA3986@linux>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH 4/7] blkio-cgroup: The body of blkio-cgroup
Date: Mon, 4 May 2009 14:05:45 +0200

> On Tue, Apr 28, 2009 at 09:46:04PM +0900, Ryo Tsuruta wrote:
> > The body of bio-cgroup.
> > 
> > Based on 2.6.30-rc3-git3
> > Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> > Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> 
> Hi Ryo,
> 
> few minor coding style issues reported by checkpatch.pl:

Thanks for reporting these issues. I'll fix them in the next release.

> 
> WARNING: line over 80 characters
> #138: FILE: include/linux/biotrack.h:67:
> +static inline void blkio_cgroup_set_owner(struct page *page, struct mm_struct *mm)
> 
> WARNING: line over 80 characters
> #152: FILE: include/linux/biotrack.h:81:
> +static inline void blkio_cgroup_copy_owner(struct page *page, struct page *opage)
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #513: FILE: mm/biotrack.c:265:
> +EXPORT_SYMBOL(get_blkio_cgroup_id);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #514: FILE: mm/biotrack.c:266:
> +EXPORT_SYMBOL(blkio_cgroup_lookup);
> 
> total: 0 errors, 4 warnings, 515 lines checked
> 
> -Andrea

Thanks,
Ryo Tsuruta
