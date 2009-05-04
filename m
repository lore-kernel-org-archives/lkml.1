Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZEDMGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZEDMGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZEDMFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:05:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:32716 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZEDMFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=izMY8xGrfAreqFdVoYvjchsW2pnMsaHlj2fJ82sfKysxw4i7vmGZT/DG0Hs0omrdrd
         X3lkvvFLE0bhWjmg/zMoiR67cyXVxv9qC/9Y3pG7Cjp4n8lzAeqwMZGztve08GrEGklV
         kOe4bLFIYNpLsV0RYHyqZlrJwnhPK9w6viEPA=
Date: Mon, 4 May 2009 14:05:45 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 4/7] blkio-cgroup: The body of blkio-cgroup
Message-ID: <20090504120544.GA3986@linux>
References: <20090428.214423.193684619.ryov@valinux.co.jp> <20090428.214457.226801820.ryov@valinux.co.jp> <20090428.214535.71090234.ryov@valinux.co.jp> <20090428.214604.104034341.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428.214604.104034341.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:46:04PM +0900, Ryo Tsuruta wrote:
> The body of bio-cgroup.
> 
> Based on 2.6.30-rc3-git3
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

Hi Ryo,

few minor coding style issues reported by checkpatch.pl:

WARNING: line over 80 characters
#138: FILE: include/linux/biotrack.h:67:
+static inline void blkio_cgroup_set_owner(struct page *page, struct mm_struct *mm)

WARNING: line over 80 characters
#152: FILE: include/linux/biotrack.h:81:
+static inline void blkio_cgroup_copy_owner(struct page *page, struct page *opage)

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#513: FILE: mm/biotrack.c:265:
+EXPORT_SYMBOL(get_blkio_cgroup_id);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#514: FILE: mm/biotrack.c:266:
+EXPORT_SYMBOL(blkio_cgroup_lookup);

total: 0 errors, 4 warnings, 515 lines checked

-Andrea
