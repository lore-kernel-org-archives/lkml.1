Return-Path: <linux-kernel-owner+w=401wt.eu-S1161328AbXCGItY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161328AbXCGItY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161329AbXCGItY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:49:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57173 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161328AbXCGItX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:49:23 -0500
Date: Wed, 7 Mar 2007 00:49:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?U+liYXN0aWVuIER1Z3Xp?= <sebastien.dugue@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-Id: <20070307004919.b5b8b7da.akpm@linux-foundation.org>
In-Reply-To: <20070307093948.188ac51c@frecb000686.frec.bull.fr>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070307093948.188ac51c@frecb000686.frec.bull.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 09:39:48 +0100 Sébastien Dugué <sebastien.dugue@bull.net> wrote:

> 
>   Hi Andrew,
> 
> On Tue, 6 Mar 2007 00:44:08 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc2/2.6.20-rc2-mm2/
> > 
> > 
> > - git-block.patch is having problems which are getting in the way - it has
> >   been dropped.
> > 
> > - As a consequence all the AIO patches were dropped
> > 
> 
>   Why? The aio notification and listio patches have nothing to do with
> git-block.patch.

Yes, I could have retained those with a little bit of jiggling.  But...

>   If you think those patches will be rendered obsolete by the new
> syslet/fibril/whatever approach, then fine.

Until this is sorted out I don't think we can add new core AIO code. 
Particularly not new syscalls.

> Otherwise do you expect me to
> resubmit?

Is OK for now, I think.
