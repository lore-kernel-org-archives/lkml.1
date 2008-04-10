Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYDJWzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYDJWzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbYDJWzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:55:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60964 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbYDJWzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H5bzzBR7EfiyPdQqUk5qnWy1dh1uRJdxH6qXMNw32rj0FJjhDdYQ2wLKEBaNORZjmucckcEaro60DmR4m1AsIik4lc+1m2ef/Ob0ue5rkGksp8BD3S82bqV5SBH5wIuAC/p2/oWVewwaIMdo9+NWNkrssJ+/5oBxnQGH6FlzwWU=
Message-ID: <86802c440804101555w760f7c7fm212cbcff62946030@mail.gmail.com>
Date: Thu, 10 Apr 2008 15:55:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor -- payload_length
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
In-Reply-To: <47FE9158.6060404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804101334j4b69373dv172ab72b072dc4a0@mail.gmail.com>
	 <47FE7A6C.1070405@zytor.com>
	 <86802c440804101415o55af93c8o8f4dc54dfad8662e@mail.gmail.com>
	 <47FE8AB1.90506@zytor.com>
	 <86802c440804101448n7fe5d04x315a30ba877774f4@mail.gmail.com>
	 <47FE9158.6060404@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 3:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > >
> > > >
> > > >
> > >  Sorry, I don't understand.
> > >
> >
> > where can i find the unzip paload size from payload hdrs?
> >
> >
>
>  The size of the unzip payload you get by looking at the last four bytes of
> the gzip payload (after verifying the existence of a gzip magic number.)
> For more specific details, look at the ELF segment headers.

output_len in vmlinux.scr?

bootloader will try to get that ?

YH
