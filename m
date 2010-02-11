Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0BKSGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:06:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47974 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab0BKSGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:06:31 -0500
To: Christoph Hellwig <hch@infradead.org>
CC: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, eugene@redhat.com, mtk.manpages@gmail.com,
       7eggert@web.de
In-reply-to: <20100211172100.GA28533@infradead.org> (message from Christoph
	Hellwig on Thu, 11 Feb 2010 12:21:00 -0500)
Subject: Re: [PATCH v2] vfs: add NOFOLLOW flag to umount(2)
References: <E1NfAXx-0000ln-59@pomaz-ex.szeredi.hu> <20100211172100.GA28533@infradead.org>
Message-Id: <E1NfdQh-0003lW-ED@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 19:06:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Christoph Hellwig wrote:
> On Wed, Feb 10, 2010 at 12:15:53PM +0100, Miklos Szeredi wrote:
> >  - renamed flag to UMOUNT_NOFOLLOW
> >  - added UMOUNT_UNUSED for feature detection
> 
> Umm, why?  MNT_ certainly isn't the best naming for unmount flags,
> but switching convention after we had a few doesn't make any sense.

It's not just bad naming, having another set of unrelated flags with
the same prefix *and* in close proximity to each other is asking for
trouble.

We could rename all the umount flags, and leave userspace do #defines
for backward compat.  It's not as if this was some widely used or
portable API.

Thanks,
Miklos
