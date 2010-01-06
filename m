Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764Ab0AFDsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0AFDsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363Ab0AFDsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:48:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab0AFDsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:48:10 -0500
Date: Tue, 5 Jan 2010 19:48:02 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
In-Reply-To: <4B4405B5.9040205@goop.org>
Message-ID: <alpine.DEB.2.01.1001051942440.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19QZFLv5AGufFMgzImHBeoMw5pwzxvAhsfSTBQ
 sQlsa3Cyc2qVjChh2H+XCMezvpvnCN+YJOgafwZDTby/LHVMuP
 PwRQXKa2jI2wSYLxTEslQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 at 14:38, Jeremy Fitzhardinge wrote:
> *Really* weird.  No idea how it could get into that state...  I've never seen
> this message before, even during development.

I've seen it only once in the xen-devel archives, but couldn't make any 
relation to my case:

http://lists.xensource.com/archives/html/xen-devel/2008-02/msg00861.html

> I'd suspect either a compiler
> bug, a miscompile, or some bad interaction with another patch.  A bisection
> would be useful.

OK, will do.

> > The Dom0 is running a 2.6.24-24-xen Ubuntu kernel amd I'm kinda reluctant
> > to upgrade, as I don't have a serial console to this MacMini, if things go

Just out of curiosity: will this be an issue in the near future? I'm 
trying to follow kernel development in my DomU, but can't upgrade Dom0 for 
quite a while, so kernel versions (DomU vs Dom0) will diverge more and 
more.

Thanks,
Christian,
-- 
BOFH excuse #74:

You're out of memory
