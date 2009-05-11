Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZEKWdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZEKWdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZEKWd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:33:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:48909 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZEKWd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:33:28 -0400
Date: Tue, 12 May 2009 08:32:31 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] cred: #include init.h in cred.h
In-Reply-To: <20090511132006.fedc9352.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.0905120831560.3090@tundra.namei.org>
References: <20090509033652.GB3224@x200.localdomain> <20090511132006.fedc9352.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Andrew Morton wrote:

> On Sat, 9 May 2009 07:36:52 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > linux/cred.h can't be included as first header (alphabetical order)
> > because it uses __init which is enough to break compilation on some
> > archs.
> > 
> 
> hm, OK, not a lot of detail there though.
> 
> > 
> > --- a/include/linux/cred.h
> > +++ b/include/linux/cred.h
> > @@ -13,6 +13,7 @@
> >  #define _LINUX_CRED_H
> >  
> >  #include <linux/capability.h>
> > +#include <linux/init.h>
> >  #include <linux/key.h>
> >  #include <asm/atomic.h>
> 
> I assume that this is needed in 2.6.30?
> 

I can see it's in -mm, so might as well go to Linus via there.

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
