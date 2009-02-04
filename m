Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZBEAyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZBEAyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZBEAyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:54:02 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51692 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbZBEAyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:54:00 -0500
Date: Thu, 5 Feb 2009 09:22:57 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090204222256.GA6954@brong.net>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain> <20090204185606.GA12991@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204185606.GA12991@elte.hu>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 07:56:06PM +0100, Ingo Molnar wrote:
>    [...] it is a natural reaction: 
>    they only see the small trivial annoyance they intruduce themselves - 
>    which is in a code area and usecase they are prominently familiar with, 
>    so they cannot personally relate to the trouble that users go through if 
>    they hit such issues.

Amen.  Preach it.  I spent quite a while just a week ago arguing that
every semi-loaded machine out there using epoll should not require the
admin to discover that their previously happy software stack was
suddenly hitting an artificially tiny per-user instances count.

Luckily I was able to find multiple blog posts and mailing list archives
with people who had literally spent _days_ tracking down why things had
broken for them when they upgraded to a new -stable kernel.

You really do have to assume that your users don't have time for this
shit.  Anything that really can't DTRT automatically needs to be covered
with plenty of easy to follow instructions on how to fix the problem -
because for someone unfamiliar with that area of the system it really 
does take enormous effort to track down what's changed.

Bron.
