Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXHBShX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXHBShX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXHBShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:37:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541AbXHBShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:37:09 -0400
Date: Thu, 2 Aug 2007 11:36:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] type safe allocator
Message-Id: <20070802113626.634a6bd9.akpm@linux-foundation.org>
In-Reply-To: <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
	<E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2007 13:31:56 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> The linux kernel doesn't have a type safe object allocator a-la new()
> in C++ or g_new() in glib.
> 
> Introduce two helpers for this purpose:
> 
>    alloc_struct(type, gfp_flags);
> 
>    zalloc_struct(type, gfp_flags);

whimper.

On a practical note, I'm still buried in convert-to-kzalloc patches, and
your proposal invites a two-year stream of 10,000 convert-to-alloc_struct
patches.

So if this goes in (and I can't say I'm terribly excited about the idea)
then I think we'd also need a maintainer who is going to handle all the
subsequent patches, run a git tree, (a quilt tree would be better, or maybe
a git tree with 100 branches), work with all the affected maintainers, make
sure there aren't clashes with other people's work and all that blah.
