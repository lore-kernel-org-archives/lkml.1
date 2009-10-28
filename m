Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZJ1FmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZJ1FmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZJ1FmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:42:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45701 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343AbZJ1FmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:42:24 -0400
Date: Wed, 28 Oct 2009 05:42:27 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: David Miller <davem@davemloft.net>
cc: dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
In-Reply-To: <20091027.222814.137568780.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0910280539150.19088@skynet.skynet.ie>
References: <alpine.DEB.2.00.0910280341331.19088@skynet.skynet.ie> <20091027.204530.142024242.davem@davemloft.net> <alpine.DEB.2.00.0910280353080.19088@skynet.skynet.ie> <20091027.222814.137568780.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Please don't do this.
> 
> This is exactly what I feared people would do when is_compat_task()
> was added.  is_compat_task() is for situations where there is
> otherwise no other way to handle the compat situation properly.
> 
> It's not that much work for you to hook up the compat ioctls properly,
> and if you are clever you can do it in such a way that you'll get
> warnings if someone accidently adds a new ioctl but forgets the
> compat bits :-)

There are close to 15 ioctls needing this, so I can add 15 functions to 
unpack and repack stuff or I can add that function, sorry if I'm 
leaning towards a lighter weight solution. I'll add this to my TODO for 
before the next merge window as its definitely more than I can manage now.

Dave.

