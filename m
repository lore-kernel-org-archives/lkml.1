Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZASCbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZASCbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZASCb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:31:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:47070 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbZASCb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:31:26 -0500
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090119095035.bf9d0e7c.sfr@canb.auug.org.au>
References: <1232273454.23100.9.camel@localhost.localdomain>
	 <20090119095035.bf9d0e7c.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 08:00:40 +0530
Message-Id: <1232332240.3129.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 09:50 +1100, Stephen Rothwell wrote:
> Hi Jaswinder,
> 
> On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >
> > diff --git a/include/linux/raw.h b/include/linux/raw.h
> > index 62d543e..3898e30 100644
> > --- a/include/linux/raw.h
> > +++ b/include/linux/raw.h
> > @@ -13,6 +13,10 @@ struct raw_config_request
> >  	__u64	block_minor;
> >  };
> >  
> > +#ifdef __KERNEL__
> >  #define MAX_RAW_MINORS CONFIG_MAX_RAW_DEVS
> > +#else /* __KERNEL__ */
> > +#define MAX_RAW_MINORS 0
> > +#endif /* __KERNEL__ */
> >  
> >  #endif /* __LINUX_RAW_H */
> 
> Since MAX_RAW_MINORS has only one user (drivers/char/raw.c), why not
> just remove the define from here and add it it there?
> 

Already fixed in v3 as pointed by Ingo.

