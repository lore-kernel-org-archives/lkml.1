Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYGHNjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYGHNjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYGHNio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:38:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2465 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751464AbYGHNij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:38:39 -0400
Date: Mon, 7 Jul 2008 13:07:31 +0200
From: Pavel Machek <pavel@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080707110730.GG5643@ucw.cz>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701081026.GB16691@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I still disagree with this whole patch.  There is not reason to let
> the freeze request timeout - an auto-unfreezing will only confuse the
> hell out of the caller.  The only reason where the current XFS freeze
> call can hang and this would be theoretically useful is when the

What happens when someone dirties so much data that vm swaps out
whatever process that frozen the filesystem?

I though that was why the timeout was there...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
