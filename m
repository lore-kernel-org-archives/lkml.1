Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYKSOF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYKSOF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYKSOFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:05:05 -0500
Received: from genesysrack.ru ([195.178.208.66]:35226 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbYKSOFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:05:03 -0500
Date: Wed, 19 Nov 2008 17:05:01 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Christoph Hellwig <hch@lst.de>
Cc: mtk.manpages@gmail.com, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081119140500.GA25968@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081118131937.GC16944@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118131937.GC16944@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph.

On Tue, Nov 18, 2008 at 02:19:37PM +0100, Christoph Hellwig (hch@lst.de) wrote:
> Yes, this kind of thing should be enable using an flag to inotify1, and
> be consistant even for rename.  Doing it as a flag to inotify1 also has
> the advantage to be able to return an -EPERM when the feature is
> requested but not allowed instead of letting applications that assume it
> silently fail.

So effectively you propose to have second generation of the inotify
which will have additional pid field, which will be unused by all but
the same uid events?

If you want to return -EPERM, than it will be _always_ returned for non
sysadmin capable user, which effectively makes it unusable.

-- 
	Evgeniy Polyakov
