Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXC3D3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXC3D3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXC3D3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:29:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbXC3D3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:29:15 -0400
Date: Thu, 29 Mar 2007 23:29:05 -0400
From: Bill Nottingham <notting@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: new sysfs layout and ethernet device names
Message-ID: <20070330032905.GA4384@nostromo.devel.redhat.com>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
References: <20070320170102.GA16341@nostromo.devel.redhat.com> <3ae72650703220147j42db8f79s734d4755c2fa43fd@mail.gmail.com> <20070328031743.GA11819@nostromo.devel.redhat.com> <20070328041005.GA7550@kroah.com> <20070329004138.GA23562@nostromo.devel.redhat.com> <20070330023104.GA21771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330023104.GA21771@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH (greg@kroah.com) said: 
> > If interfaces have to change, so be it. But changing the rules for
> > using them years after it's implemented and then claiming "you didn't
> > read the instructions" is pretty lame.
> 
> That documentation has been in the kernel tree for almost a full year:

It has a date on it. I'm not blind. That doesn't change the fact that
that documentation:

> 	Date:   Thu Apr 27 14:10:12 2006 -0700

postdates the interface it's describing by at *least* two years. Which
was the point of my mail that you conveniently ignored - retroactively
deciding which parts of the interface you export to userspace shouldn't be
used falls way short of best practices.

> Anyway, yes, older code should still "just work" if you enable the
> CONFIG_SYSFS_DEPRECATED config option in the kernel, that is what it is
> there for.

It appears to... the point was that (as far as the code is concerned)
it's a silent break. Of course, code that expects the 'current' layout
will then break when this new change is made, unless you add
CONFIG_SYSFS_SLIGHTLY_LESS_DEPRECATED?

Bill
