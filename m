Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbZDBVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbZDBVnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbZDBVmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:42:42 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:60452 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607AbZDBVml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:42:41 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 17:42:40 EDT
Subject: Re: mutex_lock_slowpath warning using mxser tty driver
 (input/output error)
From: Christophe Lermytte <christophe@lermytte.be>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 02 Apr 2009 23:37:27 +0200
Message-Id: <1238708247.5211.14.camel@cabrera>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It appears to want to lock a mutex in interrupt context, something
> > that's a definite no-no.
> > 
> > CCed the folks who might know a thing or two about the driver.

> Moxa is not a USB driver so the USB trace at the end makes no sense at
> all.

Well, it's not that I faked the traces ;-)

During the first cat, I can see the data transmitted by the device, so I guess the kernel warning is not really blocking for me at this point. 

What is blocking, is the fact that I can only do it once, before I get the input/output error. I found a post about this ( http://lkml.org/lkml/2009/3/24/269 ) and the patch seems to have made it into 2.6.29. Still having a similar issue though...


Regards,
Christophe L.


