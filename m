Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0BVVIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:08:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43406 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0BVVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:08:30 -0500
Date: Mon, 22 Feb 2010 21:08:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Valerie Aurora <vaurora@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH] VFS: Simplify truncate logic in do_filp_open()
Message-ID: <20100222210827.GF30031@ZenIV.linux.org.uk>
References: <20100222203551.GE972@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222203551.GE972@shell>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 03:35:51PM -0500, Valerie Aurora wrote:
> The fact that may_open() could truncate a file gave me a lot of
> heartburn when working on union mounts, so I was thrilled to see that
> truncate handling has been moved out of may_open() in Al's for-next
> tree.  However, it seems to me that the surrounding elaborate
> mnt_want_write() dance is no longer needed?  If so, this also
> simplifies Ogawa Hirofumi "Fix use-after-free of vfsmount by
> mnt_drop_write()" patch.
> 
> Against Al's for-next branch.  Lightly tested, please review.

Val, anything around do_filp_open() should be on top of #untested.  The
whole area gets rewritten there.
