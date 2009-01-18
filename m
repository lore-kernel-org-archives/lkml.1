Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbZARESb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbZARESb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZARESN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:18:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZARESL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:18:11 -0500
Date: Sat, 17 Jan 2009 23:18:00 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Kyle McMartin <kyle@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, linux-media@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-raid@vger.kernel.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, netdev@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
Message-ID: <20090118041800.GB671@bombadil.infradead.org>
References: <1232223441.3966.22.camel@localhost.localdomain> <1232228261.27094.0.camel@macbook.infradead.org> <20090117221932.GA4956@uranus.ravnborg.org> <1232247901.3097.12.camel@localhost.localdomain> <20090118033339.GA671@bombadil.infradead.org> <1232249904.3097.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232249904.3097.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 09:08:24AM +0530, Jaswinder Singh Rajput wrote:
> If this file is _ONLY_ for userspace and kernel cannot use it then what
> is the point of keeping this file in kernel headers.
> 

There is effectively no point, especially when they reference a variable
that may or may not exist in the userspace code including it... It seems
entirely mtd-utils dependent.

Dave, will you queue Adrian's patch to nuke it?

