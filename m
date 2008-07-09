Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYGIGQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYGIGQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGIGQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:16:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYGIGQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:16:39 -0400
Date: Wed, 9 Jul 2008 02:16:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tytso@mit.edu, pavel@suse.cz, hch@infradead.org, t-sato@yk.jp.nec.com,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709061621.GA5260@infradead.org>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 08:13:21AM +0200, Miklos Szeredi wrote:
> This would mean that freeze and thaw will have to be done on the same
> file descriptor, but this isn't unreasonable to expect, is it?

It is certainly not the current use case, where you run one command
to freeze the filesystem and another one to unfreeze it.

