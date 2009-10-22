Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZJVAdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZJVAdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZJVAdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:33:55 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:46757 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbZJVAdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:33:54 -0400
Subject: Re: Question about invalidate_inode_pages2_range()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peng Tao <lkml.bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6149e97b0910202108i3f66bdfesa4425ed1eab8bcb8@mail.gmail.com>
References: <f2201a0b0910190116w29cd5e3w1ae2c76bd677f9ed@mail.gmail.com>
	 <1255940788.14447.7.camel@heimdal.trondhjem.org>
	 <6149e97b0910190138k5791351dmc95d9cc636aaef2f@mail.gmail.com>
	 <1256016346.12592.15.camel@heimdal.trondhjem.org>
	 <6149e97b0910202108i3f66bdfesa4425ed1eab8bcb8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 20:33:55 -0400
Message-Id: <1256171635.6809.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 2 msgs/h 1 sum rcpts/h 7 sum msgs/h 2 total rcpts 1726 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 6A94EA80813D53F6CE23CF6E4B7976EFC99EB8A0
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 317 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 12:08 +0800, Peng Tao wrote:
> On Tue, Oct 20, 2009 at 1:25 PM, Trond Myklebust
> <trond.myklebust@fys.uio.no> wrote:
> > On Mon, 2009-10-19 at 16:38 +0800, Peng Tao wrote:
> >> 2. Is there any interface in the mm subsystem forces discarding a page cache?
> >
> > You mean that also discards dirty pages? Yes. That is what
> > truncate_inode_pages() does...
> But truncate_inode_pages() truncates all pages beyond lstart.
> Is there any way to discard a single page?
> truncate_inode_page() seems to be able to do the magic. But it is not exported.

truncate_inode_pages_range() is your friend...

Cheers
  Trond

