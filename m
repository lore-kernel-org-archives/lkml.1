Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXAWGpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXAWGpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933091AbXAWGpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:45:52 -0500
Received: from outbound0.mx.meer.net ([209.157.153.23]:2906 "EHLO
	outbound0.sv.meer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbXAWGpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:45:51 -0500
Subject: Re: `make htmldocs` fails -- 2.6.20-rc4-mm1
From: Don Mullis <dwm@meer.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
In-Reply-To: <20070122222238.b6628c6b.rdunlap@xenotime.net>
References: <20070111222627.66bb75ab.akpm@osdl.org>
	 <m364aycmbt.fsf@meer.net>  <20070122222238.b6628c6b.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Mon, 22 Jan 2007 22:45:46 -0800
Message-Id: <1169534747.5146.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-22 at 22:22 -0800, Randy Dunlap wrote:
> On Mon, 22 Jan 2007 22:02:30 -0800 Don Mullis wrote:
> 
> > 
> > Bisection shows the bad patch to be:
> >     gregkh-driver-uio-documentation.patch
> > 
> > The htmldocs build failure can be eliminated by:
> >     quilt remove Documentation/DocBook/kernel-api.tmpl
> 
> or by:  quilt delete gregkh-driver-uio-documentation.patch ??

That would fix the htmldoc build too, but would throw out lots of
documentation.  Greg K-H would seem the prime candidate to propose a
fix.


> How about an accurate description of what kernel tree has this problem?
> It's not 2.6.19.  It's not 2.6.20-rc5.

2.6.20-rc4-mm1, sorry.  Forgot that posting as a reply to the
2.6.20-rc4-mm1 announcement is no help for someone receiving the mail
directly.


