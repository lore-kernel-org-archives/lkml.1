Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYJOUUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYJOUUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYJOUUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:20:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYJOUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:20:23 -0400
Date: Wed, 15 Oct 2008 16:20:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] vfs: remove unnecessary fsnotify_d_instantiate()
Message-ID: <20081015202019.GA28686@infradead.org>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp> <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp> <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp> <524881153e848f5f6f3426623.ps@mail.parknet.co.jp> <20081015194334.GB24892@infradead.org> <878wsppq9x.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wsppq9x.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 05:16:58AM +0900, OGAWA Hirofumi wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Wed, Oct 15, 2008 at 10:58:11PM +0900, OGAWA Hirofumi wrote:
> >> 
> >> This calls d_move(), so fsnotify_d_instantiate() is unnecessary like
> >> rename path.
> >
> > fsnotify_d_instantiate and fsnotify_d_move call into different inotify
> > functions.  Did you verify that this really does the right thing?
> > (Sorry, not in a mood to look into idiotify code..)
> 
> Yes. I checked it.

Then the patch looks good to me.
