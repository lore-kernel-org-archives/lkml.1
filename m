Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYFBOfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYFBOfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYFBOfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:35:25 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:52963 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYFBOfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:35:24 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <200806021613.15088.arnd@arndb.de>
References: <200805311737.58991.arnd@arndb.de> <200806021315.41211.arnd@arndb.de> <6880.1212411400@jrobl> <200806021613.15088.arnd@arndb.de>
Date: Mon, 02 Jun 2008 23:33:29 +0900
Message-ID: <8353.1212417209@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann:
> > By the way, how do you think link(2) or rename(2)? When the source file
> > exists on the lower writable branch, do you think copy-up is the best
> > way? Or do you think all lower branches should be readonly?
> > There is an exception in aufs's branch-select policy. That is
> > link/rename case. When the source file exists on a writable branch, aufs
> > tries link/rename it on that branch in every policy. Do you think it
> > best to do it on the top branch only?
> 
> Yes, I tend to consider the union case identical to the cross-mount
> move or link, so I'd expect the kernel to return errno=EXDEV and user
> space to handle this by doing the appropriate copy/unlink as it does
> for other cases already.

Aure rename returns EXDEV when the target is a dir and it has child
entr(y|ies) on lower branhc(es). And mv(1) handles this case.
My Engilsh might be miunderstood. Do you think link(2) should return an
error when the target exists on lower writable branch?


Junjiro Okajima
