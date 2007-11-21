Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbXKUEFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbXKUEFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 23:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXKUEFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 23:05:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:28748 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbXKUEFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 23:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CukPbFRupau8/RfiSb8QBMrt0FOgQg6131JtpS0ujeuWUOq0prk7tWQxQ5MxSwfm/eb/BoYiKaUi6VG5A1yXDU+J5G+3HsmeWFp4iNCcURsJ+ufT+sGUKA3yQryZ3NKLiw2z38TbitG1Ke5tN2uweI+gBJnEgcLG/AlgBdJDzgQ=
Message-ID: <f17812d70711202005m110ae880m5ba195988e57a638@mail.gmail.com>
Date: Wed, 21 Nov 2007 12:05:41 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: ian <spyro@f2s.com>
Subject: Re: [patch] 0/4 Support for Toshiba TMIO multifunction devices
Cc: "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "ARM Linux" <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1195617255.2329.78.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195591234.2329.52.camel@wirenth> <474359E3.2020603@gmail.com>
	 <1195597252.2329.70.camel@wirenth>
	 <f17812d70711201823w6201bf88uf6268aaee3a32312@mail.gmail.com>
	 <1195617255.2329.78.camel@wirenth>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 21, 2007 11:54 AM, ian <spyro@f2s.com> wrote:
> On Wed, 2007-11-21 at 10:23 +0800, eric miao wrote:
> > Roughly went through the patch, looks good, here comes the remind, though :-)
> >
> > 1. is it possible to use some name other than "soc_core", maybe
> > "tmio_core" so that other multifunction chips sharing a core base
> > will live easier.
>
> It's (soc-core) not tmio MFD specific - its already used by other MFD
> chips (although obviously not ones in mainline (yet!)
>
> it might be better named 'mfd-core' though, as thats its intended use...
>
> > 2. those C++ style comments "//" are not so pleasant...
>
> Should I clean them up and resubmit?
>

Will be nice then, anyway, could you inline them so others can comment?

> More to the point, who should I be submitting them to? the files under
> arm/ are obviously for RMK to peruse, but I couldnt find an entry for
> drivers/mfd in MAINTAINERS...
>

Well, I briefly went through the git history, looks like Russell is the proper
one you could sent them to (probably not) :-)

>
>



-- 
Cheers
- eric
