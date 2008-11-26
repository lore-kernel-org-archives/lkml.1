Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYKZMvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYKZMvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYKZMvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:51:16 -0500
Received: from cs-studio.ru ([195.178.208.66]:41118 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYKZMvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:51:15 -0500
Date: Wed, 26 Nov 2008 15:51:13 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Newall <davidn@davidnewall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, john@johnmccutchan.com,
       arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de, rlove@rlove.org,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@suse.cz,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-ID: <20081126125113.GA8921@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net> <492D4560.8000302@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492D4560.8000302@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 11:17:28PM +1030, David Newall (davidn@davidnewall.com) wrote:
> I don't think so.  As discussed,
> (http://marc.info/?l=linux-kernel&m=122735413932519), you already can
> differentiate I/O made by local users, so you don't need to modify inotify.

And as was shown it does not work for all cases and introduces unneded
performance overhead.

> This change violates my first rule of programming: If there's two or
> more ways of solving a problem, pick one; don't pick them all.

Then we should go back to caves, raw meat was so tasty...

-- 
	Evgeniy Polyakov
