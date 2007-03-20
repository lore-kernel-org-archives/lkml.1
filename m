Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXCTJHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXCTJHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXCTJHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:07:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbXCTJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AItRnDOQ+dXnp7CuyKTE6+9/ITJKGLn76c5p0kbLK8FKE0itxhyocKPMsC7rR3rdGwG2TlYOM/KGulJASY60KiNztZecKRDBZkgdbMxPA3voy5bXvmKQjVcKwFKRHyJZPJOFJfRVxU5h7mNuO0dFXlgRBD4Vre4iiUNlZeb5ufg=
Message-ID: <6bffcb0e0703200207k324484eep6082da3f244b07a8@mail.gmail.com>
Date: Tue, 20 Mar 2007 10:07:27 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45FF6E55.4060101@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	 <45FEE33C.1020706@googlemail.com>
	 <20070319140827.285dcc7f.akpm@linux-foundation.org>
	 <6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>
	 <20070319175852.c73406f1.akpm@linux-foundation.org>
	 <20070319180234.6b7826b2.akpm@linux-foundation.org>
	 <45FF4B59.3060107@yahoo.com.au>
	 <20070319205645.4918d978.akpm@linux-foundation.org>
	 <45FF6E55.4060101@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Andrew Morton wrote:
> > On Tue, 20 Mar 2007 13:47:53 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >
> >
> >>Andrew Morton wrote:
> >>
>
> >>Hang on a sec... I'll try fixing the thing before you next make a
> >>release.
> >>
> >
> >
> > Too late.  hot-fixes/ awaits thee.
>
> Awww... well thanks very much Michal for reporting the bug, I reproduced
> it easily and it turns out to be a typo.
>
> In my testing I never had a lot of writeout going on, so most of the pages
> will have been truncated in the first loop...
>

Problem fixed. Thanks!

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
