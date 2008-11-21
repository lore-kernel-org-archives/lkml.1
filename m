Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYKUODi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYKUODi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYKUOD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:03:28 -0500
Received: from broadrack.ru ([195.178.208.66]:35651 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbYKUOD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:03:28 -0500
Date: Fri, 21 Nov 2008 17:03:25 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Pavel Machek <pavel@suse.cz>
Cc: mtk.manpages@gmail.com, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081121140325.GA12384@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120130902.GA1408@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 02:09:03PM +0100, Pavel Machek (pavel@suse.cz) wrote:
> > > It is a minimum functionality extension that serves the needs of one
> > > or a few projects, while dirtying the design for all users.
> > 
> > Yes, this is a minimum functionality extension, which breaks nothing.
> > That's why it is a good idea, but I agree that there may be better than
> > just a good idea and implementation :)
> 
> Breaks nothing?!
> 
> Introducing ugly hack with broken permission check we have to maintain
> forever seems like way too much breakage for 14 lines.

Apparently you missed the patch itself.
Please check it first before making such statements.

> > And I actually answered, that this may be a good idea for the new
> > project. Although if things work right now no one will ever try to
> > change it. It does not work in my case, so I need to invent as simple
> > as possible way to fix it.
> 
> 'as simple diff as possible' is pretty bad criterium for kernel
> merges.

Critics without suggestions is useless. What did you try to say here?
You you believe it should be done in a different way, please tell us how
you see this should be implemented.

-- 
	Evgeniy Polyakov
