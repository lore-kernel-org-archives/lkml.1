Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYEENn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYEENn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbYEENnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:43:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45573 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbYEENno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:43:44 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, menage@google.com
In-reply-to: <20080505133322.GA14370@infradead.org> (message from Christoph
	Hellwig on Mon, 5 May 2008 09:33:22 -0400)
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
References: <20080505095440.820370974@szeredi.hu> <20080505095511.217634550@szeredi.hu> <20080505110016.GC20910@infradead.org> <E1Jszri-0005uq-4x@pomaz-ex.szeredi.hu> <20080505130804.GA1809@infradead.org> <E1Jt0l8-00066L-NC@pomaz-ex.szeredi.hu> <20080505133322.GA14370@infradead.org>
Message-Id: <E1Jt0yf-00069Q-1M@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 15:43:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We do have a good reason: r/o bind mounts and AppArmor.  And please
> > don't tell me, you also think that moving the security hooks to
> > callers is a good idea ;)  That would actually be a change with a much
> > larger impact, both in terms of code duplication and of verifying
> > correctness.
> 
> I think AppArmor is a horribly stupid idea to start with, and I'm not
> willing up to mess up the kernel tree for it.

Well, I'd hardly call this whole patchset messing up the kernel, and
you seemed to agree with most of the patches.

It may come as a surprise, but all of it (as well as reviews of the
r/o bind patches which found some pretty serious bugs) are because I'm
trying to work on integrating AppArmor cleanly.

You may consider it a stupid idea, and it may or may not be one.  But
please try to be a bit more constructive on the issue.

Thanks,
Miklos
