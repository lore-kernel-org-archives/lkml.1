Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbXJXCsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbXJXCsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXJXCse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:48:34 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:36375 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbXJXCsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:48:33 -0400
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20071024023512.GW27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
	 <1193192346.8691.36.camel@perkele>
	 <20071024023512.GW27248@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 22:48:32 -0400
Message-Id: <1193194112.8866.7.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-23 at 20:35 -0600, Matthew Wilcox wrote:

[...]

> > Multiple string objects can share the same data, by increasing the nrefs
> > count, a new data is allocated if the string is modified and nrefs > 1.
> 
> If we were trying to get rid of char * throughout the kernel, that might
> make some sense; stringbufs have a more limited target though.
> 

[...]

No contest, my suggestions only make sense for a general uses string
library.

I suspect most in-kernel string manipulations are limited to prepare
buffers to be copied to (and read from) user-space.


- Eric


