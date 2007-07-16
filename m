Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbXGPVR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbXGPVR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759778AbXGPVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:17:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759258AbXGPVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:17:11 -0400
Date: Mon, 16 Jul 2007 14:01:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: wrong order of arguments of ->readdir()
Message-Id: <20070716140134.389f1669.akpm@linux-foundation.org>
In-Reply-To: <20070716204930.GK21668@ftp.linux.org.uk>
References: <200707152359.l6FNx3oN023117@hera.kernel.org>
	<20070716134424.0cd870b4.akpm@linux-foundation.org>
	<20070716204930.GK21668@ftp.linux.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 21:49:30 +0100
Al Viro <viro@ftp.linux.org.uk> wrote:

> On Mon, Jul 16, 2007 at 01:44:24PM -0700, Andrew Morton wrote:
> > Today is not being a good day.
> > 
> > This bug was already fixed.   The following mistakes were made:
> > 
> > a) Jan's patch was misleadingly titled "coda: avoid lockdep warning in
> >    coda_readdir"
> > 
> > b) Jan's patch had no changelog
> > 
> > c) Jen's patch was not cc'ed to any mailing list
>  
> ... said patch (presumably being an obvious fix of obvious roothole)
> had not been sent to mainline immediately.

Please send a copy to stable@kernel.org

> > d) Al's patch was not sent to the maintainer.  Nor to me.  Nor was it
> >    staged in any tree which I can get at so that I could inform people of
> >    the upcoming conflict/duplication/etc.
>  
> Coda is still maintained?  That's certainly news to me - I'm not being
> sarcastic, but my impression had been that coda got abandoned several
> years ago.

Jan does stuff occasionally.
