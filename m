Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbXHBNGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbXHBNGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXHBNGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:06:04 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:46550 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXHBNGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:06:03 -0400
To: viro@ftp.linux.org.uk
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-reply-to: <20070802120515.GL21089@ftp.linux.org.uk> (message from Al Viro
	on Thu, 2 Aug 2007 13:05:15 +0100)
Subject: Re: [RFC PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> <alpine.LFD.0.999.0708012051100.3582@woody.linux-foundation.org> <E1IGV6D-0000rM-00@dorka.pomaz.szeredi.hu> <20070802120515.GL21089@ftp.linux.org.uk>
Message-Id: <E1IGaMv-0001ZT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Aug 2007 15:05:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Folks, this is serious.  _We_ might be used to having in effect a C dialect
> with extensions implemented by preprocessor.  That's fine, but for a fresh
> reader it becomes a problem; sure, they can dig in include/linux/*.h and
> to some extent they clearly have to.  However, it doesn't come for free
> and we really ought to keep that in mind - amount of local idioms (and
> anything that doesn't look like a normal function call with normal arguments
> _does_ become an idiom to be learnt before one can fluently RTFS) is a thing
> to watch out for.

That's why the g_new() form that glib uses makes some sense.  It
borrows an idiom from C++, and although we all know C++ is a horrid
language, to some extent lots of people are familiar with it.

> IOW, whenever we add to that pile we ought to look hard at whether it's worth
> the trouble.

Well, this is not some earth-shattering stuff, but I think it would be
good to have.  I got used to it in glib, and I miss it in linux.

I understand the knee-jerk reaction of most people who are unfamiliar
with it, and I can do nothing about that.  If there's no positive
feedback I'll just give up, it's not that I can't live with the
current situation.


Miklos
