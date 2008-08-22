Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYHVSR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYHVSR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYHVSRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:17:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbYHVSQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:16:59 -0400
Date: Fri, 22 Aug 2008 14:16:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-fsdevel@vger.kernel.org,
       dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
       axboe@kernel.dk, mtk.manpages@googlemail.com,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080822181656.GB15469@infradead.org>
References: <20080818212856t-sato@mail.jp.nec.com> <20080821132006.9949101c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821132006.9949101c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 01:20:06PM -0700, Andrew Morton wrote:
> I don't think the changelogs actually explained why this feature is
> being added?
> 
> Which userspace tools are expected to send these ioctls?  Something in
> util-linux?  dm-utils?  Are patches to those packages planned?

Currently the only surspace using freeze and thaw is xfs_freeze from
xfsprogs, which would work for various other filesystems that implement
->write_super_lockfs now instead of just XFS with patch 1.

The freeze stuff in this third patch isn't and won't be used by
xfs_freeze and doesn't make all that much sense (and we already had a
lot of previous discussion on this..)

