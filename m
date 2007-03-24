Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbXCXU10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbXCXU10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 16:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbXCXU10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 16:27:26 -0400
Received: from pfepc.post.tele.dk ([195.41.46.237]:52995 "EHLO
	pfepc.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbXCXU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 16:27:25 -0400
Subject: Re: race condition in dm-crypt?
From: Kasper Sandberg <lkml@metanurb.dk>
To: Christoph Maier <lists@christoph-maier.de>
Cc: jckn@gmx.net, linux-kernel@vger.kernel.org
In-Reply-To: <46043B77.60703@christoph-maier.de>
References: <20070323170535.GA3057@hejre.minidns.net>
	 <46043B77.60703@christoph-maier.de>
Content-Type: text/plain
Date: Sat, 24 Mar 2007 21:27:23 +0100
Message-Id: <1174768043.13793.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 21:41 +0100, Christoph Maier wrote:
> Jan C. Nordholz wrote:
> > I think I'm experiencing a race condition: Irregularly my kernel runs
> > into an Oops when it tries to initialize my crypt containers.
> 
> FYI, there are similiar reports on the net, going as far back as May 2006:
> http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/1636 
> is the oldest one I could find.
> 
> Bugzilla entry: http://bugzilla.kernel.org/show_bug.cgi?id=7388
> 
> I, too, ran into the bug and failed to reproduce it. However, it might 
> be worth knowing that the system went to 100% iowait afterwards.
Very interresting actually. I myself run dm-crypt and somewhat regularly
my io stops for 5-10 seconds, with seemingly no errors or high load, io
just stalls, and then returns after a while.

> 
> Regards, Christoph Maier
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

