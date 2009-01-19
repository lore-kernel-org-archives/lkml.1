Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZASCcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZASCcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbZASCbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:31:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:47087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011AbZASCbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:31:49 -0500
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090119105324.fd4e9084.sfr@canb.auug.org.au>
References: <1232273454.23100.9.camel@localhost.localdomain>
	 <20090119105324.fd4e9084.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 08:01:14 +0530
Message-Id: <1232332274.3129.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 10:53 +1100, Stephen Rothwell wrote:
> Hi Jaswinder,
> 
> On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >
> > diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
> > index 04b4d73..277de8c 100644
> > --- a/include/linux/pktcdvd.h
> > +++ b/include/linux/pktcdvd.h
> > @@ -33,11 +33,15 @@
> >   * able to sucessfully recover with this option (drive will return good
> >   * status as soon as the cdb is validated).
> >   */
> > +#ifdef __KERNEL__
> >  #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
> >  #define USE_WCACHING		1
> >  #else
> >  #define USE_WCACHING		0
> >  #endif
> > +#else /* __KERNEL__ */
> > +#define USE_WCACHING		0
> > +#endif /* __KERNEL__ */
> 
> This also only has one user (drivers/block/pktcdvd.c) so maybe it should
> be moved there.
> 

Already fixed in v3 as pointed by Ingo.

Thanks,

--
JSR

