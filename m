Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbZAUB2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbZAUB2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZAUB20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:28:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:41726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbZAUB2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:28:25 -0500
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090118110221.GA29602@elte.hu>
References: <1232273454.23100.9.camel@localhost.localdomain>
	 <20090118110221.GA29602@elte.hu>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 06:57:56 +0530
Message-Id: <1232501276.3123.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Sun, 2009-01-18 at 12:02 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > --- a/include/linux/types.h
> > +++ b/include/linux/types.h
> > @@ -138,6 +138,7 @@ typedef		__s64		int64_t;
> >   *
> >   * blkcnt_t is the type of the inode's block count.
> >   */
> > +#ifdef __KERNEL__
> >  #ifdef CONFIG_LBD
> >  typedef u64 sector_t;
> >  typedef u64 blkcnt_t;
> > @@ -145,6 +146,10 @@ typedef u64 blkcnt_t;
> >  typedef unsigned long sector_t;
> >  typedef unsigned long blkcnt_t;
> >  #endif
> > +#else /* __KERNEL__ */
> > +typedef unsigned long sector_t;
> > +typedef unsigned long blkcnt_t;
> > +#endif /* __KERNEL__ */
> 

What is your patch for this case.

Thanks,
--
JSR

