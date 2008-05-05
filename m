Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYEENdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYEENdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYEENd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:33:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYEENdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:33:25 -0400
Date: Mon, 5 May 2008 09:33:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       menage@google.com
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
Message-ID: <20080505133322.GA14370@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095511.217634550@szeredi.hu> <20080505110016.GC20910@infradead.org> <E1Jszri-0005uq-4x@pomaz-ex.szeredi.hu> <20080505130804.GA1809@infradead.org> <E1Jt0l8-00066L-NC@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jt0l8-00066L-NC@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 03:29:38PM +0200, Miklos Szeredi wrote:
> We do have a good reason: r/o bind mounts and AppArmor.  And please
> don't tell me, you also think that moving the security hooks to
> callers is a good idea ;)  That would actually be a change with a much
> larger impact, both in terms of code duplication and of verifying
> correctness.

I think AppArmor is a horribly stupid idea to start with, and I'm not
willing up to mess up the kernel tree for it.
