Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbZEKVQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbZEKVQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZEKVQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:16:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbZEKVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oodBxPlV2ZoBzO5l9TRSZna16DNQ428ZdvWy5qVqOdbtEhzjAvlsNPhkjL8mdAx5gh
         XyVEFn5tvQ6Z/Hz72x9yw5TvSFEI38+dxgI7ITCgh77w7WzSN1TM0cB9jEIXcjtzKg5g
         yY1ItL+pGvASNx/21tQ697uQUf+JUAtjvYa7U=
Date: Tue, 12 May 2009 01:16:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] cred: #include init.h in cred.h
Message-ID: <20090511211639.GA15982@x200.localdomain>
References: <20090509033652.GB3224@x200.localdomain> <20090511132006.fedc9352.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511132006.fedc9352.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 01:20:06PM -0700, Andrew Morton wrote:
> On Sat, 9 May 2009 07:36:52 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:

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

Would be nice.
