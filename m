Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZHaNVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZHaNVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZHaNVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:21:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZHaNVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:21:49 -0400
Date: Mon, 31 Aug 2009 09:21:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Ric Wheeler <rwheeler@redhat.com>,
       Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090831132139.GA5425@infradead.org>
References: <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com> <20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9BCDFE.50008@rtr.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 09:19:58AM -0400, Mark Lord wrote:
>> In my opinion even that is too weak.  We know how to control the cache
>> settings on all common disks (that is scsi and ata), so we should always
>> disable the write cache unless we know that the whole stack (filesystem,
>> raid, volume managers) supports barriers.  And even then we should make
>> sure the filesystems does actually use barriers everywhere that's needed
>> which failed at for years.
> ..
>
> That stack does not know that my MD device has full battery backup,
> so it bloody well better NOT prevent me from enabling the write caches.

No one is going to prevent you from doing it.  That question is one of
sane defaults.  And always safe, but slower if you have advanced
equipment is a much better default than usafe by default on most of
the install base.

