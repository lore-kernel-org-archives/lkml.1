Return-Path: <linux-kernel-owner+w=401wt.eu-S1763824AbXHAJnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763824AbXHAJnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbXHAJng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:43:36 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:38365 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431AbXHAJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:43:35 -0400
To: bunk@stusta.de
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070801092909.GN3972@stusta.de> (message from Adrian Bunk on
	Wed, 1 Aug 2007 11:29:09 +0200)
Subject: Re: [RFC PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> <20070801092909.GN3972@stusta.de>
Message-Id: <E1IGAiD-0006Qf-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Aug 2007 11:41:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I wonder why we don't have type safe object allocators a-la new() in
> > C++ or g_new() in glib?
> > 
> >   fooptr = k_new(struct foo, GFP_KERNEL);
> > 
> > is nicer and more descriptive than
> > 
> >   fooptr = kmalloc(sizeof(*fooptr), GFP_KERNEL);
> >...
> 
> But it's much more likely to break when someone converts fooptr to a 
> different struct.
> 
> It might not be a common case but it sometimes happens - and your type 
> safe variant introduces the possibility for really nasty bugs.

The compiler would emit a warning about assigning to a pointer of
different type.  That's a fairly strong hint that something just
broke.

Miklos
