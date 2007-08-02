Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbXHBSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbXHBSsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXHBSso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:48:44 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:57503 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbXHBSsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:48:43 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
In-reply-to: <20070802113626.634a6bd9.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 2 Aug 2007 11:36:26 -0700)
Subject: Re: [PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
	<E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu> <20070802113626.634a6bd9.akpm@linux-foundation.org>
Message-Id: <E1IGfik-0002Y1-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Aug 2007 20:48:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The linux kernel doesn't have a type safe object allocator a-la new()
> > in C++ or g_new() in glib.
> > 
> > Introduce two helpers for this purpose:
> > 
> >    alloc_struct(type, gfp_flags);
> > 
> >    zalloc_struct(type, gfp_flags);
> 
> whimper.
> 
> On a practical note, I'm still buried in convert-to-kzalloc patches, and
> your proposal invites a two-year stream of 10,000 convert-to-alloc_struct
> patches.
> 
> So if this goes in

No, I gave up.  It seems nobody likes the idea except me :(

Miklos
