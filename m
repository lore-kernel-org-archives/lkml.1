Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbXJXVUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbXJXVUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXJXVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:19:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3655 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbXJXVT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:19:58 -0400
Subject: Re: Stringbuf, v2
From: Joe Perches <joe@perches.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071024205701.GF27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org>
	 <1193259097.19617.18.camel@localhost>
	 <20071024205701.GF27248@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 14:06:33 -0700
Message-Id: <1193259993.19617.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 14:57 -0600, Matthew Wilcox wrote:
> If you look at the patches, you'll see that they basically all have a
> wrapper around sb_printf that I was able to insert the GFP argument
> into, so I don't see this as a win.

I was hoping that each module/subsystem would not need a
separate wrapper and could use the plain sb_printf function.


