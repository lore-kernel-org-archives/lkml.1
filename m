Return-Path: <linux-kernel-owner+w=401wt.eu-S1423072AbXDXTjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423072AbXDXTjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423083AbXDXTjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:39:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60825 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423072AbXDXTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:39:24 -0400
Date: Tue, 24 Apr 2007 21:39:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Edward Shishkin <edward@namesys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Andi Kleen <andi@firstfloor.org>, Alex Zarochentsev <zam@namesys.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Eric Hopper <hopper@omnifarious.org>, Lex Lyamin <flx@msu.ru>,
       William Heimbigner <icxcnika@mar.tar.cc>,
       Rik van Riel <riel@redhat.com>, Xu CanHao <xucanhao@gmail.com>
Subject: Re: Question about Reiser4
Message-ID: <20070424193921.GA17129@one.firstfloor.org>
References: <20070423111939.c876c9cc.akpm@linux-foundation.org> <462E17AF.7090604@namesys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462E17AF.7090604@namesys.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Because there are unaddressed items in this todo list:
> http://pub.namesys.com/Reiser4/ToDo
> The main issues here are xattrs and support for blocksize != pagesize.

I would consider both to be optional. We have various file systems
in tree that don't support either (e.g. JFS only supports 4K blocks
and OCFS2 doesn't support xattr) They shouldn't block merging.

> 2. Who will maintain this?
> 
> Currently there are two namesys employees working mostly on
> enthusiasm. Divide them into 2 file systems, plus many people who
> really help with fixing problems.

Merging will probably be a peak of work for the necessary changes,
then hopefully the work will be less once you're in tree because
you don't need to track mainline anymore
(assuming not to many bugs come in from users) 

-Andi
