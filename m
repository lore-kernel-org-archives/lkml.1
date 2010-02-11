Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0BKRVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:21:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0BKRVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:21:05 -0500
Date: Thu, 11 Feb 2010 12:21:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH v2] vfs: add NOFOLLOW flag to umount(2)
Message-ID: <20100211172100.GA28533@infradead.org>
References: <E1NfAXx-0000ln-59@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NfAXx-0000ln-59@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 12:15:53PM +0100, Miklos Szeredi wrote:
>  - renamed flag to UMOUNT_NOFOLLOW
>  - added UMOUNT_UNUSED for feature detection

Umm, why?  MNT_ certainly isn't the best naming for unmount flags,
but switching convention after we had a few doesn't make any sense.

