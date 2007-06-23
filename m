Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbXFWXhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbXFWXhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 19:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXFWXgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 19:36:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbXFWXgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 19:36:54 -0400
Date: Sat, 23 Jun 2007 16:36:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: spock@gentoo.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fbdev: uvesafb driver
Message-Id: <20070623163639.f6b4f20d.akpm@linux-foundation.org>
In-Reply-To: <20070623232033.GB7148@spock.one.pl>
References: <20070623105243.GD12623@spock.one.pl>
	<20070623113557.f0295218.akpm@linux-foundation.org>
	<20070623232033.GB7148@spock.one.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 01:20:33 +0200 Michal Januszewski <spock@gentoo.org> wrote:

> > > +config FB_UVESA
> > > +	tristate "Userspace VESA VGA graphics support"
> > > +	depends on FB && CONNECTOR
> > 
> > These dependencies are insufficient.
> 
> What exactly is missing here?  A dep on X86?

Yes.  From your other comments it appears that a dependency on X86_32 is
needed.

>  This would indicate the
> arches on which the driver has actually been tested.  But which arches
> are supported and which aren't is, in the end, up to the userspace helper.

The other architectures won't compile: they don't have mtrr.h
