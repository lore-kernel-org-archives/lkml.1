Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbYDVIHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbYDVIHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYDVIHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:07:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1839 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872AbYDVIHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:07:35 -0400
Date: Tue, 22 Apr 2008 10:07:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 11/11] s390: convert to generic helpers for IPI  function calls
Message-ID: <20080422080730.GR12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-12-git-send-email-jens.axboe@oracle.com> <1208851490.10852.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208851490.10852.0.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Martin Schwidefsky wrote:
> On Tue, 2008-04-22 at 09:57 +0200, Jens Axboe wrote:
> > diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
> > index 3873646..17b16b1 100644
> > --- a/arch/sparc64/kernel/sparc64_ksyms.c
> > +++ b/arch/sparc64/kernel/sparc64_ksyms.c
> > @@ -112,6 +112,7 @@ EXPORT_SYMBOL(__write_unlock);
> >  EXPORT_SYMBOL(__write_trylock);
> > 
> >  EXPORT_SYMBOL(smp_call_function);
> > +EXPORT_SYMBOL(smp_call_function_single);
> >  #endif /* CONFIG_SMP */
> > 
> >  #if defined(CONFIG_MCOUNT)
> 
> This does not belong into the s390 patch ;-)

Woops, I wonder how that got in there! Thanks, will kill it.

-- 
Jens Axboe

