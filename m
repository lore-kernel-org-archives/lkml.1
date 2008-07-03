Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbYGCOeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbYGCOeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYGCOdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:33:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46157 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYGCOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:33:53 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       Artem.Bityutskiy@nokia.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20080702194249.GV28946@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 2 Jul 2008 20:42:50 +0100)
Subject: Re: [patch] vfs: fix lookup on deleted directory
References: <E1KE81v-0000d8-Kp@pomaz-ex.szeredi.hu> <20080702194249.GV28946@ZenIV.linux.org.uk>
Message-Id: <E1KEPsV-0002TO-5t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Jul 2008 16:33:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

On Wed, 2 Jul 2008, Al Viro wrote:
> I wonder if it would be better to do that in a slightly different way:
> if ->lookup() returns negative dentry, check if parent is dead and drop
> the sucker if it is.

Either is fine by me.

OT: could we have some feedback about patches I submitted during the
last couple of weeks?  They aren't terribly complex, so really I don't
think it would take more than 10 minutes of your time to review and
ack/nack them.

But even just saying that you're busy and will look at them at
whatever time would be better than the complete silence that usually
follows patch submissions.

Also there's the unprivileged mounts patchset, that has been waiting
for the last year or so.  That's a bit more complex stuff, but it's
not going to get better by sitting around in -mm.  Is there a
possibility of that getting reviewed for 2.6.27?

Thanks,
Miklos
