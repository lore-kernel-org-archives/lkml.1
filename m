Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZARDjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZARDjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 22:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZARDjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 22:39:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:33035 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZARDjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 22:39:33 -0500
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de,
       linux-media@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
       linux-nfs@vger.kernel.org, linux-raid@vger.kernel.org,
       dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, netdev@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090118033339.GA671@bombadil.infradead.org>
References: <1232223441.3966.22.camel@localhost.localdomain>
	 <1232228261.27094.0.camel@macbook.infradead.org>
	 <20090117221932.GA4956@uranus.ravnborg.org>
	 <1232247901.3097.12.camel@localhost.localdomain>
	 <20090118033339.GA671@bombadil.infradead.org>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 09:08:24 +0530
Message-Id: <1232249904.3097.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 22:33 -0500, Kyle McMartin wrote:
> On Sun, Jan 18, 2009 at 08:35:01AM +0530, Jaswinder Singh Rajput wrote:
> > Hello Sam, David,
> > 
> > /home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/mtd/jffs2-user.h:20: extern's make no sense in userspace
> > 
> 
> This file is for userspace only, and it makes sense where it's used
> (mtd-utils.)
> 
> In general though, this file doesn't actually depend on the kernel and
> could be entirely provided from the userspace library.
> 

If this file is _ONLY_ for userspace and kernel cannot use it then what
is the point of keeping this file in kernel headers.

--
JSR



